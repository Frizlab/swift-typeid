/*
 * TypeID.swift
 * TypeID
 *
 * Created by François Lamboley on 2023/06/28.
 */

import Foundation



public struct TypeID : RawRepresentable {
	
	/**
	 The setter for the prefix is not public because it must be validated.
	 
	 An empty prefix is valid. */
	public private(set) var prefix: String
	public var uuid: UUIDv7
	
	/** If the given prefix is `nil`, the resulting ``TypeID`` will have an empty (but non-nil) prefix. */
	public init?(prefix: String?, uuid: UUIDv7) {
		guard prefix?.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz").inverted) == nil else {
			/* The prefix must be lower-case ascii-only as per the specs. */
			return nil
		}
		
		self.prefix = prefix ?? ""
		self.uuid = uuid
	}
	
	public init?(rawValue: String) {
		/* We accept TypeID starting with an “_”, though technically if the prefix is empty the “_” should be dropped. */
		let components = rawValue.split(separator: "_", maxSplits: 1, omittingEmptySubsequences: false)
		assert(components.count == 1 || components.count == 2)
		
		let uuidString = String(components.count == 1 ? components[0] : components[1])
		guard let uuid = UUID(base32EncodedString: uuidString), let uuidv7 = UUIDv7(rawValue: uuid) else {
			return nil
		}
		
		self.init(prefix: components.count == 2 ? String(components[0]) : "", uuid: uuidv7)
	}
	
	public var rawValue: String {
		if prefix.isEmpty {return                uuid.rawValue.base32EncodedString()}
		else              {return prefix + "_" + uuid.rawValue.base32EncodedString()}
	}
	
}
