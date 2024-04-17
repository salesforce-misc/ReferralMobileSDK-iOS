# ReferralMobileSDK-iOS

ReferralMobileSDK-iOS is designed to facilitate the integration of referral program functionalities in iOS applications. It simplifies the process of enrolling users in referral programs, managing referral events, and handling various referral-related operations, leveraging the capabilities of the Referral API.

**Where:** This SDK is applicable in all iOS environments supporting Swift and can be integrated into any iOS application.

**How:** Integrate the ReferralMobileSDK-iOS into your project, configure the necessary parameters, and start using the available APIs to manage referral activities.

## Supported Versions of Tools and Components

| Tool or Component     | Supported Version |
|-----------------------|-------------------|
| Swift Version         | 5.7+              |
| Xcode                 | 14.0+             |
| iOS SDK               | 15.0+             |

## Installation

To integrate the ReferralMobileSDK-iOS in your Xcode project, follow these steps:

1. Open your app project in Xcode, navigate to **File** → **Swift Packages** → **Add Package Dependency**.
2. Enter the repository URL: `https://github.com/salesforce-misc/ReferralMobileSDK-iOS`
3. Choose the appropriate version and add the package to your project.

## Import SDK in an iOS Swift Project

To use the ReferralMobileSDK-iOS, add the following import statement in your Swift file:

```swift
import ReferralMobileSDK
```

## ReferralAPIManager

The `ReferralAPIManager` class is the core of the SDK, providing functionalities to manage referral related operations. Key functionalities include:

- Enrolling users in referral programs using different identifiers like membership numbers or contact IDs.
- Managing referral events and tracking their outcomes.
- Customizing API calls based on the referral program's needs.

### Usage Examples

#### Enrolling a New Member

```swift
let referralAPIManager = ReferralAPIManager(auth: authManager, referralProgramName: "YourReferralProgramName", instanceURL: "YourInstanceURL", forceClient: forceClient)

let result = try await referralAPIManager.referralEnrollment(firstName: "John", lastName: "Doe", email: "john.doe@example.com", membershipNumber: "1234567890", promotionCode: "PromoCode")
```

#### Enrolling an Existing Member with Membership Number

```swift
let result = try await referralAPIManager.referralEnrollment(membershipNumber: "1234567890", promotionCode: "PromoCode")
```

#### Handling a Referral Event

```swift
let eventOutput = try await referralAPIManager.referralEvent(email: "john.doe@example.com", referralCode: "ReferralCode")
```

For more detailed examples and a full list of functionalities, please refer to the `ReferralAPIManager` class documentation.

## Contribute to the SDK

You can contribute to the development of the Referral Mobile SDK. 
1. Fork the Referral Mobile SDK for iOS [repository](https://github.com/salesforce-misc/ReferralMobileSDK-iOS).
2. Create a branch with a descriptive name.
3. Implement your changes.
4. Test your changes.
5. Submit a pull request.

See also:
[Fork a repo](https://docs.github.com/en/get-started/quickstart/fork-a-repo)

## License

ReferralMobileSDK-iOS is available under the BSD 3-Clause License.

Copyright (c) 2024, Salesforce Industries
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
