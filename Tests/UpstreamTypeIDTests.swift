/*
 * UpstreamTypeIDTests.swift
 * TypeIDTests
 *
 * Created by François Lamboley on 2023/06/30.
 */

import XCTest
@testable import TypeID



final class UpstreamTypeIDTests: XCTestCase {
	
	func testInvalidPrefix() throws {
		let testData = [
			"PREFIX",
			"12323",
			"pre.fix",
			"  ",
			"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
		]
		
		for datum in testData {
			XCTAssertNil(TypeID(prefix: datum))
		}
	}
	
	func testInvalidSuffix() throws {
		let testData = [
			"  ",
			"01234",
			"012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789",
			"00041061050R3GG28A1C60T3GF",
			"00041061050-3gg28a1-60t3gf",
			"ooo41o61o5or3gg28a1c6ot3gi",
			"00041061050.3gg28a1_60t3gf",
			"ooooooiiiiiiuuuuuuulllllll"
		]
		
		for datum in testData {
			XCTAssertNil(TypeID(prefix: "prefix", base32EncodedUUID: datum))
		}
	}
	
	func testInvalidTypeids() throws {
		struct TestEntry : Decodable {
			var name: String
			var typeid: String
			var description: String
		}
		let testEntriesJSON = try Data(contentsOf: Self.testsDataPath.appendingPathComponent("invalid-typeids.json"))
		let testEntries = try JSONDecoder().decode([TestEntry].self, from: testEntriesJSON)
		
		for testEntry in testEntries {
			XCTAssertNil(TypeID(rawValue: testEntry.typeid), "\(testEntry.name)")
		}
	}
	
	func testEncodeDecode() throws {
		/* Generate a bunch of random typeids, encode and decode from a string and make sure the result is the same as the original. */
		for _ in 0..<1000 {
			let tid = try XCTUnwrap(TypeID(prefix: "prefix"))
			let decoded = try XCTUnwrap(TypeID(rawValue: tid.rawValue))
			XCTAssertEqual(tid, decoded)
		}
		
		/* Repeat with the empty prefix. */
		for _ in 0..<1000 {
			let tid = try XCTUnwrap(TypeID(prefix: "")) /* Note: We can use a nil prefix in our library. */
			let decoded = try XCTUnwrap(TypeID(rawValue: tid.rawValue))
			XCTAssertEqual(tid, decoded)
		}
	}
	
	func testSpecialValues() throws {
		let testData = [
			(tid: "00000000000000000000000000", uuid: "00000000-0000-0000-0000-000000000000"),
			(tid: "00000000000000000000000001", uuid: "00000000-0000-0000-0000-000000000001"),
			(tid: "0000000000000000000000000a", uuid: "00000000-0000-0000-0000-00000000000a"),
			(tid: "0000000000000000000000000g", uuid: "00000000-0000-0000-0000-000000000010"),
			(tid: "00000000000000000000000010", uuid: "00000000-0000-0000-0000-000000000020"),
		]
		
		for testDatum in testData {
			let typeid = try XCTUnwrap(TypeID(rawValue: testDatum.tid))
			let uuid = try XCTUnwrap(UUID(uuidString: testDatum.uuid))
			XCTAssertEqual(typeid.uuid, uuid)
			XCTAssertEqual(TypeID(prefix: nil, uuid: uuid)?.rawValue, testDatum.tid)
		}
	}
	
	func testValidTypeids() throws {
		struct TestEntry : Decodable {
			var name: String
			var typeid: String
			var prefix: String
			var uuid: UUID
		}
		print("yolo: \(Self.testsDataPath)")
		let testEntriesJSON = try Data(contentsOf: Self.testsDataPath.appendingPathComponent("valid-typeids.json"))
		let testEntries = try JSONDecoder().decode([TestEntry].self, from: testEntriesJSON)
		
		for testEntry in testEntries {
			let tid = try XCTUnwrap(TypeID(rawValue: testEntry.typeid))
			XCTAssertEqual(tid.uuid,   testEntry.uuid)
			XCTAssertEqual(tid.prefix, testEntry.prefix)
		}
	}
	
	func testPerfs() throws {
		measure{
			let typeid = TypeID(prefix: "test")!
			XCTAssertEqual(typeid, TypeID(rawValue: typeid.rawValue))
		}
	}
	
#if canImport(Darwin)
	@available(tvOS 13.0, iOS 13.0, watchOS 7.0, *)
	func testPerfWithOptions() throws {
		let options = {
			let res = XCTMeasureOptions.default
			res.iterationCount = 5000
			return res
		}()
		measure(options: options, block: {
			let typeid = TypeID(prefix: "test")!
			XCTAssertEqual(typeid, TypeID(rawValue: typeid.rawValue))
		})
	}
#endif
	
}
