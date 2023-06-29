/*
 * TypeIDTests.swift
 * TypeIDTests
 *
 * Created by François Lamboley on 2023/06/29.
 */

import XCTest
@testable import TypeID



final class TypeIDTests: XCTestCase {
	
	func testReadmeExample() throws {
		let id = try XCTUnwrap(TypeID(prefix: "user"))
		XCTAssert(id.rawValue.hasPrefix("user_"))
	}
	
	func testInitEmptyPrefix() throws {
		let typeID = try XCTUnwrap(TypeID(prefix: "", uuid: UUIDv7()))
		let rawValue = typeID.rawValue
		XCTAssertFalse(rawValue.starts(with: "_"))
		print(rawValue)
		XCTAssertEqual(rawValue.count, 26)
	}
	
	func testInitRawValueNoPrefix() throws {
		let typeID = try XCTUnwrap(TypeID(rawValue: "01h426wjehf2sszbjbsdcj7wb4"))
		XCTAssertTrue(typeID.prefix.isEmpty)
	}
	
	func testInitInvalidPrefix() throws {
		XCTAssertNil(TypeID(prefix: "Hello", uuid: UUIDv7()))
		XCTAssertNil(TypeID(rawValue: "._" + UUIDv7().rawValue.base32EncodedString()))
	}
	
	func testInitNormalPrefix() throws {
		XCTAssertNotNil(TypeID(prefix: "user", uuid: UUIDv7()))
		XCTAssertNotNil(TypeID(rawValue: "user_" + UUIDv7().rawValue.base32EncodedString()))
	}
	
}
