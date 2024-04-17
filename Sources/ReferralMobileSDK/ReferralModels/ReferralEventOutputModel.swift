/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - ReferralEventOutputModel
public struct ReferralEventOutputModel: Codable {
    public let contactIDs, referralIDs: [String]
    public let transactionjournalIDs: [String]?
    public let voucherID, referralStage: String?

    enum CodingKeys: String, CodingKey {
        case contactIDs = "contactIds"
        case referralIDs = "referralIds"
        case referralStage
        case transactionjournalIDs = "transactionjournalIds"
        case voucherID = "voucherId"
    }
}
