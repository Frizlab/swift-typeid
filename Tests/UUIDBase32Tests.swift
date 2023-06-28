/*
 * UUIDBase32Tests.swift
 * TypeIDTests
 *
 * Created by François Lamboley on 2023/06/29.
 */

import XCTest
@testable import TypeID



final class UUIDBase32Tests: XCTestCase {
	
	func testSimpleKnownUUID() throws {
		let uuid: uuid_t = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		XCTAssertEqual(UUID(uuid: uuid).base32EncodedString(), "00000000000000000000000000")
	}
	
}
