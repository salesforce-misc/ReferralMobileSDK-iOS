/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import ReferralMobileSDK

class MockNetworkManager: NetworkManagerProtocol {
            public var statusCode = 200
            
            func handleUnauthResponse(output: URLSession.DataTaskPublisher.Output) throws {
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    Logger.error(CommonError.requestFailed(message: "Invalid response").description)
                    throw CommonError.requestFailed(message: "Invalid response")
                }

                switch httpResponse.statusCode {
                case 200..<300:
                    break
                case 401:
                    Logger.error(CommonError.authenticationNeeded.description)
                    throw CommonError.authenticationNeeded
                case 403:
                    Logger.error(CommonError.functionalityNotEnabled.description)
                    throw CommonError.functionalityNotEnabled
                default:
                    let errorMessage = "HTTP response status code \(httpResponse.statusCode)"
                    Logger.error(CommonError.responseUnsuccessful(message: errorMessage, displayMessage: "").description)
                    Logger.debug(httpResponse.description)
                    throw CommonError.responseUnsuccessful(message: errorMessage, displayMessage: "")
                }
            }
            
            static let sharedMock = MockNetworkManager()
            
            func fetch<T>(type: T.Type, request: URLRequest, urlSession: URLSession) async throws -> T where T: Decodable {
                let data = try await responseData(type: T.Type.self)
                let mockSession = URLSession.mock(responseBody: data, statusCode: statusCode)
                let output = try await mockSession.data(for: request)
                try handleUnauthResponse(output: output)
                statusCode = 200
                
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
                return try decoder.decode(type, from: output.0)
            }
            
            func responseData<T>(type: T.Type) async throws -> Data {
                if type.self == ReferralEnrollmentOutputModel.Type.self {
                    return try XCTestCase.load(resource: "ReferralEnrollmentOutput")
                } else if type.self == ReferralEventOutputModel.Type.self {
                    return try XCTestCase.load(resource: "ReferralEventOutput")
                }
                
                return Data()
            }
        }
