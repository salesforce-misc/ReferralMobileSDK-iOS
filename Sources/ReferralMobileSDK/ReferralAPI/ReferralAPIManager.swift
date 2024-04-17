/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A class for managing requests related to loyalty programs using the Referral API.
public class ReferralAPIManager {
    
    /// An instance of `ForceAuthenticator` for authentication
    public var auth: ForceAuthenticator
    
    /// The name of the referral program
    public var referralProgramName: String
    
    /// The base URL of the loyalty program API
    public var instanceURL: String
    
    /// An instance of `ForceClient` to handle API requests
    private var forceClient: ForceClient
    
    /// Initializes a `ReferralAPIManager` with the necessary parameters.
    public init(auth: ForceAuthenticator, referralProgramName: String, instanceURL: String, forceClient: ForceClient) {
        self.auth = auth
        self.referralProgramName = referralProgramName
        self.instanceURL = instanceURL
        self.forceClient = forceClient
    }
    
    /// Enumeration for identifying the type of resource to request.
    public enum Resource {
        case referralEnrollment(referralProgramName: String, promotionCode: String, version: String)
        case referralEvent(version: String)
    }
    
    /// Get path for given API resource
    /// - Parameter resource: A ``Resource``
    /// - Returns: A string represents URL path of the resource
    public func getPath(for resource: Resource) -> String {
        
        switch resource {
        case .referralEnrollment(let referralProgramName, let promotionCode, let version):
            return ForceAPI.path(for: "referral-programs/\(referralProgramName)/promotions/\(promotionCode)/member-enrollments", version: version)
        case .referralEvent(let version):
            return ForceAPI.path(for: "referral-program/referral-event", version: version)
        }
    }
    
    /// Use Case 3: Existing Referral Advocate enrolling to a Promotion with Membership number
    public func referralEnrollment(membershipNumber: String,
                                   promotionCode: String,
                                   memberStatus: String = MemberStatus.active.rawValue,
                                   version: String = ReferralAPIVersion.defaultVersion,
                                   devMode: Bool = false) async throws -> ReferralEnrollmentOutputModel {
        
        let body = [
            "membershipNumber": membershipNumber,
            "memberStatus": memberStatus
        ]
        
        do {
            let path = getPath(for: .referralEnrollment(referralProgramName: referralProgramName, promotionCode: promotionCode, version: version))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
            return try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: request)
        } catch {
            throw error
        }
    }

    /// Use Case 2: Existing Referral Advocate enrolling to a Promotion with Contact Id
    public func referralEnrollment(contactID: String,
                                   promotionCode: String,
                                   memberStatus: String = MemberStatus.active.rawValue,
                                   version: String = ReferralAPIVersion.defaultVersion,
                                   devMode: Bool = false) async throws -> ReferralEnrollmentOutputModel {

        let body = [
            "contactId": contactID,
            "memberStatus": memberStatus
        ]
        
        do {
            let path = getPath(for: .referralEnrollment(referralProgramName: referralProgramName, promotionCode: promotionCode, version: version))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
            return try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    /// Use case 1: New Member (No contact or membership id i.e. not a loyalty member)
    public func referralEnrollment(firstName: String,
                                   lastName: String,
                                   email: String,
                                   membershipNumber: String,
                                   promotionCode: String,
                                   enrollmentChannel: ReferralEnrollmentChannel = ReferralEnrollmentChannel.mobile,
                                   memberStatus: String = MemberStatus.active.rawValue,
                                   tjStatementFrequency: TransactionJournal​StatementFrequency = .monthly,
                                   tjStatementMethod: TransactionJournal​StatementMethod = .email,
                                   version: String = ReferralAPIVersion.defaultVersion,
                                   devMode: Bool = false) async throws -> ReferralEnrollmentOutputModel {

        do {
            let body: [String: Any] = [
                "associatedPersonAccountDetails": [
                    "allowDuplicateRecords": "false",
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                ],
                "enrollmentChannel": enrollmentChannel.rawValue,
                "memberStatus": memberStatus,
                "membershipNumber": membershipNumber,
                "transactionJournalStatementFrequency": tjStatementFrequency.rawValue,
                "transactionJournalStatementMethod": tjStatementMethod.rawValue
            ]
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)

            // Prepare and execute the network request
            let path = getPath(for: .referralEnrollment(referralProgramName: referralProgramName, promotionCode: promotionCode, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
            return try await forceClient.fetch(type: ReferralEnrollmentOutputModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    public func referralEvent(email: String,
                              referralCode: String,
                              eventType: ReferralEventType = .refer,
                              version: String = ReferralAPIVersion.defaultVersion,
                              devMode: Bool = false) async throws -> ReferralEventOutputModel {
        do {
            let emails = [email]
            return try await referralEvent(emails: emails, referralCode: referralCode,eventType: eventType, version: version, devMode: devMode)
        } catch {
            throw error
        }
    }
    
    public func referralEvent(emails: [String],
                              referralCode: String,
                              eventType: ReferralEventType = .refer,
                              version: String = ReferralAPIVersion.defaultVersion,
                              devMode: Bool = false) async throws -> ReferralEventOutputModel {
        do {
            let currentDate = DateFormatter.forceFormatter(.medium).string(from: Date())
            
            let body: [String : Any] = [
                "referralCode": referralCode,
                "referralEmails": [
                  "emails": emails
                ],
                "activityDateTime": currentDate,
                "eventType": eventType.rawValue
            ]
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            
            let path = getPath(for: .referralEvent(version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
            return try await forceClient.fetch(type: ReferralEventOutputModel.self, with: request)
        } catch {
            throw error
        }
    }

}
