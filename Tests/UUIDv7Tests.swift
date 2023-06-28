import XCTest
@testable import TypeID



final class UUIDv7Tests: XCTestCase {
	
	func testSimpleKnownUUID() throws {
		let uuidv7 = try XCTUnwrap(UUIDv7(millisecondsTimestamp: 0))
		XCTAssertEqual(uuidv7.date, Date(timeIntervalSince1970: 0))
	}
	
}
