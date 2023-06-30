/*
 * TypeID+Codable.swift
 * TypeID
 *
 * Created by François Lamboley on 2023/06/30.
 */

import Foundation



extension TypeID : Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		guard let typeid = TypeID(rawValue: rawValue) else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid typeid raw value")
		}
		self = typeid
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
	
}
