/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - ReferralEventInputModel
struct ReferralEventInputModel: Codable {
    public let referralCode, contactID: String
    public let firstName, lastName: String?
    public let referralEmails: ReferralEmails
    public let eventType: ReferralEventType
    public let joiningDate, productID: String
    public let purchaseAmount: Double
    public let purchaseQuantity: Int
    public let referralAdditionalAttributes: ReferralAdditionalAttributes
    public let transactionJournalAdditionalAttributes: TransactionJournalAdditionalAttributes
    public let orderReferenceID: String

    enum CodingKeys: String, CodingKey {
        case referralCode
        case contactID = "contactId"
        case referralEmails
        case firstName, lastName, joiningDate, eventType
        case productID = "productId"
        case purchaseAmount, purchaseQuantity, referralAdditionalAttributes, transactionJournalAdditionalAttributes
        case orderReferenceID = "orderReferenceId"
    }
}

// MARK: - AdditionalAttributes
public struct ReferralAdditionalAttributes: Codable {
    public let attributes: Attributes
}

public struct ReferralEmails: Codable {
    public let emails: [String]
}

// MARK: - Attributes
public struct Attributes: Codable {
    public let phoneNumber: String
    public let emailOptOut: Bool
}

// MARK: - TransactionJournalAdditionalAttributes
public struct TransactionJournalAdditionalAttributes: Codable {
}
// MARK: - ReferralEventType

public enum ReferralEventType: String, Codable {
    case enrollment = "Enrollment"
    case purchase = "Purchase"
    case refer = "Refer"
}
