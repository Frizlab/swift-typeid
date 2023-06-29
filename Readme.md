# swift-typeid
An implementation of [`typeid`](https://github.com/jetpack-io/typeid) in Swift.

## Usage

Example usage of TypeID in a Swift project:
```swift
import TypeID

let id = TypeID(prefix: "user")! /* Force-unwrap is valid as we _know_ the prefix "user" is valid. */
print(id.rawValue)

let purposefullyImpreciseID = TypeID(prefix: "user", allowedDateDelta: 120)!
/* The resulting ID has a date between now-2min and now+2min. */
```
