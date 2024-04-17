
/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - ReferralEnrollmentInputModel
public struct ReferralEnrollmentInputModel: Codable {
    public let associatedPersonAccountDetails: AssociatedPersonAccountDetails?
    public let memberStatus, transactionJournalStatementFrequency, transactionJournalStatementMethod, enrollmentChannel: String?
    public let additionalMemberFieldValues: AdditionalMemberFieldValues?
}

// MARK: - AdditionalMemberFieldValues
public struct AdditionalMemberFieldValues: Codable {
    public let attributes: AdditionalMemberFieldValuesAttributes?
}

// MARK: - AdditionalMemberFieldValuesAttributes
public struct AdditionalMemberFieldValuesAttributes: Codable {
}

// MARK: - AssociatedPersonAccountDetails
public struct AssociatedPersonAccountDetails: Codable {
    public let firstName, lastName, email, allowDuplicateRecords: String
    public let additionalPersonAccountFieldValues: AdditionalPersonAccountFieldValues?
}

// MARK: - AdditionalPersonAccountFieldValues
public struct AdditionalPersonAccountFieldValues: Codable {
    public let attributes: AdditionalPersonAccountFieldValuesAttributes?
}

// MARK: - AdditionalPersonAccountFieldValuesAttributes
public struct AdditionalPersonAccountFieldValuesAttributes: Codable {
}

// MARK: - ReferralEnrollmentChannel

public enum ReferralEnrollmentChannel: String, Codable {
    case callCenter = "CallCenter"
    case email = "Email"
    case franchise = "Franchise"
    case mobile = "Mobile"
    case partner = "Partner"
    case pos = "Pos"
    case print = "Print"
    case social = "Social"
    case store = "Store"
    case web = "Web"
}
// MARK: - TransactionJournal​StatementFrequency

public enum TransactionJournal​StatementFrequency: String, Codable {
    case monthly = "Monthly"
    case quarterly = "Quarterly"
}

// MARK: - TransactionJournal​StatementMethod

public enum TransactionJournal​StatementMethod: String, Codable {
    case email = "Email"
    case mail = "Mail"
}

public enum MemberStatus: String, Codable {
    case active = "Active"
    case inactive = "Inactive"
}
