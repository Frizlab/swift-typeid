# 🪪 swift-typeid

<picture><img alt="Compatible from Swift 5.5 to 6." src="https://img.shields.io/badge/Swift-6.0_%7C_5.10--5.5-blue"></picture>
<picture><img alt="Compatible with macOS, iOS, visionOS, tvOS and watchOS." src="https://img.shields.io/badge/Platforms-macOS_%7C_iOS_%7C_visionOS_%7C_tvOS_%7C_watchOS-blue"></picture>
<picture><img alt="Compatible with Linux, Windows, WASI and Android." src="https://img.shields.io/badge/Platforms-Linux_%7C_Windows_%7C_WASI_%7C_Android-blue"></picture>
[![](<https://img.shields.io/github/v/release/Frizlab/swift-typeid>)](<https://github.com/Frizlab/swift-typeid/releases>)

An implementation of [`typeid`](https://github.com/jetpack-io/typeid) in Swift.

## Usage

Example usage of TypeID in a Swift project:
```swift
import TypeID

let id = TypeID(prefix: "user")! /* Force-unwrap is valid as we _know_ the prefix “user” is valid. */
print(id.rawValue) /* Will print something like “user_01h4285mqdepf8jrk9e1mjdjm1”. */

let purposefullyImpreciseID = TypeID(prefix: "user", allowedDateDelta: 120)!
/* The resulting ID has a date between now-2min and now+2min. */
```
