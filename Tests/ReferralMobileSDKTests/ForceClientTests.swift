/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import ReferralMobileSDK

final class ForceClientTests: XCTestCase {
    private var forceClient: ForceClient!

    override func setUp() {
        forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: MockNetworkManager.sharedMock)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        forceClient = nil
    }
    
    func getMockRequest() async throws -> URLRequest {
        
        let path = "referral-program/referral-event"
        let request = try  ForceRequest.create(instanceURL: "https://instanceUrl", path: path, method: "POST")
        return request
    }
    
    func testFetchLocalJson() async throws {
        let result = try forceClient.fetchLocalJson(type: ReferralEnrollmentOutputModel.self, file: "ReferralEnrollmentOutput", bundle: Bundle.module)
        XCTAssertNotNil(result)
        
        do {
            _ = try forceClient.fetchLocalJson(type: ReferralEnrollmentOutputModel.self, file: "ReferralEnrollmentOutput", bundle: Bundle.main)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testFetchReferralenrollment() async throws {
        MockNetworkManager.sharedMock.statusCode = 200
        let data = try XCTestCase.load(resource: "ReferralEnrollmentOutput")
        let mockSession = URLSession.mock(responseBody: data, statusCode: 200)
        let enrollmentOutputModel = try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: getMockRequest(), urlSession: mockSession)
        XCTAssertNotNil(enrollmentOutputModel)

        
        MockAuthenticator.sharedMock.needToThrowError = true
        // Handle authentication failed scenrio
        do {
            let enrollmentOutputModel = try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: getMockRequest(), urlSession: mockSession)
            XCTAssertNotNil(enrollmentOutputModel)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
        
        MockAuthenticator.sharedMock.needToThrowError = false
        
        MockNetworkManager.sharedMock.statusCode = 401
        var mockSessionWithError = URLSession.mock(responseBody: data, statusCode: 401)
        // Handle authentication failed scenrio
        do {
            let enrollmentOutputModel = try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: getMockRequest(), urlSession: mockSessionWithError)

            XCTAssertNotNil(enrollmentOutputModel)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
        
        MockNetworkManager.sharedMock.statusCode = 403
        mockSessionWithError = URLSession.mock(responseBody: data, statusCode: 403)
        // Handle other error failed scenrio
        do {
            let enrollmentOutputModel = try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: getMockRequest(), urlSession: mockSessionWithError)

            XCTAssertNotNil(enrollmentOutputModel)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.functionalityNotEnabled)
        }

    }
}
