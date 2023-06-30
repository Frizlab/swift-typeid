/*
 * TypeID.swift
 * TypeID
 *
 * Created by François Lamboley on 2023/06/28.
 */

import Foundation



public struct TypeID : RawRepresentable, Hashable {
	
	/**
	 The setter for the prefix is not public because it must be validated.
	 
	 An empty prefix is valid. */
	public private(set) var prefix: String
	public var uuid: UUID
	
	/** If the given prefix is `nil`, the resulting ``TypeID`` will have an empty (but non-nil) prefix. */
	public init?(prefix: String?, base32EncodedUUID: String) {
		guard let uuid = UUID(base32EncodedString: base32EncodedUUID) else {
			return nil
		}
		self.init(prefix: prefix, uuid: uuid)
	}
	
	/** If the given prefix is `nil`, the resulting ``TypeID`` will have an empty (but non-nil) prefix. */
	public init?(prefix: String?, uuid: UUID = UUIDv7().rawValue) {
		guard prefix?.count ?? 0 < 64,
				prefix?.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz").inverted) == nil
		else {
			/* The prefix must be shorter than 64 characters and lower-case ascii-only as per the specs. */
			return nil
		}
		
		self.prefix = prefix ?? ""
		self.uuid = uuid
	}
	
	public init?(prefix: String?, allowedDateDelta: TimeInterval?) {
		self.init(prefix: prefix, uuid: UUIDv7(allowedDateDelta: allowedDateDelta).rawValue)
	}
	
	public init?(rawValue: String) {
		/* We do not accept TypeID starting with an “_”.
		 * We used to do it, but tests from upstream say we must not. */
		guard !rawValue.starts(with: "_") else {
			return nil
		}
		
		let components = rawValue.split(separator: "_", maxSplits: 1, omittingEmptySubsequences: false)
		assert(components.count == 1 || components.count == 2)
		
		let uuidString = String(components.count == 1 ? components[0] : components[1])
		guard let uuid = UUID(base32EncodedString: uuidString) else {
			return nil
		}
		
		self.init(prefix: components.count == 2 ? String(components[0]) : "", uuid: uuid)
	}
	
	public var rawValue: String {
		if prefix.isEmpty {return                uuid.base32EncodedString()}
		else              {return prefix + "_" + uuid.base32EncodedString()}
	}
	
}
