/*
 * UUIDv7+Codable.swift
 * TypeID
 *
 * Created by François Lamboley on 2025/03/18.
 */

import Foundation



extension UUIDv7 : Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(UUID.self)
		guard let v7 = UUIDv7(rawValue: rawValue) else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid UUIDv7 value")
		}
		self = v7
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
	
}
