/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import ReferralMobileSDK
class MockAuthenticator: ForceAuthenticator {
    static let sharedMock = MockAuthenticator()
    
    var needToThrowError = false
    
    func getAccessToken() -> String? {
        guard !needToThrowError else { return nil }
        return "AccessToken1234"
    }
    
    func grantAccessToken() async throws -> String {
        return "AccessToken1234"
    }
    
}

final class APIManagerTests: XCTestCase {

private var referralAPIManager: ReferralAPIManager!
    
    override func setUp() {
        super.setUp()
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: MockNetworkManager.sharedMock)
        referralAPIManager = ReferralAPIManager(auth: MockAuthenticator.sharedMock, referralProgramName: "", instanceURL:"https://instanceUrl", forceClient: forceClient)
        
    }
    
    func testReferralEnrollmentWithContact() async throws {
        MockNetworkManager.sharedMock.statusCode = 200
        let identity = try await referralAPIManager.referralEnrollment(contactID: "", promotionCode: "")
        XCTAssertNotNil(identity)
        
        let devIdentity = try await referralAPIManager.referralEnrollment(contactID: "", promotionCode: "", devMode: true)
        
        XCTAssertNotNil(devIdentity)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await referralAPIManager.referralEnrollment(contactID: "", promotionCode: "")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testReferralEnrollmentWithNewMember() async throws {
        MockNetworkManager.sharedMock.statusCode = 200
        let identity = try await referralAPIManager.referralEnrollment(firstName: "Test", lastName: "user", email: "", membershipNumber: "123456", promotionCode: "")
        XCTAssertNotNil(identity)
        
        let devIdentity = try await referralAPIManager.referralEnrollment(firstName: "Test", lastName: "user", email: "", membershipNumber: "123456", promotionCode: "", devMode: true)
        
        XCTAssertNotNil(devIdentity)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await referralAPIManager.referralEnrollment(firstName: "Test", lastName: "user", email: "", membershipNumber: "123456", promotionCode: "")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testReferralEnrollmentWithMember() async throws {
        MockNetworkManager.sharedMock.statusCode = 200
        let identity = try await referralAPIManager.referralEnrollment(membershipNumber: "", promotionCode: "")
        XCTAssertNotNil(identity)
        
        let devIdentity = try await referralAPIManager.referralEnrollment(membershipNumber: "", promotionCode: "", devMode: true)
        
        XCTAssertNotNil(devIdentity)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await referralAPIManager.referralEnrollment(membershipNumber: "", promotionCode: "")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testReferralEvent() async throws {
        MockNetworkManager.sharedMock.statusCode = 200
        let identity = try await referralAPIManager.referralEvent(email: "test@gmail.com", referralCode: "")
        XCTAssertNotNil(identity)
        
        let devIdentity = try await referralAPIManager.referralEvent(email: "test@gmail.com", referralCode: "", devMode: true)
        
        XCTAssertNotNil(devIdentity)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
             _ = try await referralAPIManager.referralEvent(email: "test@gmail.com", referralCode: "")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    override func tearDown() {
        referralAPIManager = nil
        super.tearDown()
    }

}
