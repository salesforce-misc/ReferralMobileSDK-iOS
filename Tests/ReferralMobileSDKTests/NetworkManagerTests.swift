/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import ReferralMobileSDK

final class NetworkManagerTests: XCTestCase {

    let forceNetworkManager = NetworkManager.shared
    
    func getMockRequest() async throws -> URLRequest {
        
        let path = "referral-program/referral-event"
        let request = try  ForceRequest.create(instanceURL: "https://instanceUrl", path: path, method: "POST")
        return request
    }
    
    func testHandleDataAndResponse() async throws {
        let data = try XCTestCase.load(resource: "ReferralEnrollmentOutput")
        let mockSession = URLSession.mock(responseBody: data, statusCode: 200)
        let output = try await mockSession.data(for: getMockRequest())
        let outputData = try forceNetworkManager.handleDataAndResponse(output: output)
        let dateFormatters = DateFormatter.forceFormatters()
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
                        
            for dateFormatter in dateFormatters {
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "NetworkManager cannot decode date string \(dateString)")
        }
        let referralEnrollmentModel = try decoder.decode(ReferralEnrollmentOutputModel.self, from: outputData)

        XCTAssertNotNil(referralEnrollmentModel)
    }
    
    func testHandleUnauthResponse() async throws {
        let data = try XCTestCase.load(resource: "ReferralEnrollmentOutput")
        var mockSession = URLSession.mock(responseBody: data, statusCode: 401)
        var output = try await mockSession.data(for: getMockRequest())
        XCTAssertThrowsError(try forceNetworkManager.handleDataAndResponse(output: output)) { error in
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
        
        mockSession = URLSession.mock(responseBody: data, statusCode: 403)
        output = try await mockSession.data(for: getMockRequest())
        XCTAssertThrowsError(try forceNetworkManager.handleDataAndResponse(output: output)) { error in
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.functionalityNotEnabled)
        }
    }
    
    func testFetch() async throws {
        let data = try XCTestCase.load(resource: "ReferralEnrollmentOutput")
        let mockSession = URLSession.mock(responseBody: data, statusCode: 200)
        let referralEnrollmentModel = try await forceNetworkManager.fetch(type: ReferralEnrollmentOutputModel.self, request: getMockRequest(), urlSession: mockSession)
        XCTAssertNotNil(referralEnrollmentModel)
        let mockSession1 = URLSession.mock(responseBody: data, statusCode: 401)
        
        // Handle authentication failed scenrio
        do {
            _ = try await forceNetworkManager.fetch(type: ReferralEnrollmentOutputModel.self, request: getMockRequest(), urlSession: mockSession1)
            XCTAssertNotNil(referralEnrollmentModel)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
        
        let mockSession2 = URLSession.mock(responseBody: data, statusCode: 201)
        // Handle authentication failed scenrio
        do {
            _ = try await forceNetworkManager.fetch(type: ReferralEnrollmentOutputModel.self, request: getMockRequest(), urlSession: mockSession2)
            XCTAssertNotNil(referralEnrollmentModel)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }

}

