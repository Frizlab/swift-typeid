/*
 * TypeID.swift
 * TypeID
 *
 * Created by François Lamboley on 2023/06/28.
 */

import Foundation



/**
 A [UUIDv7](<https://datatracker.ietf.org/doc/html/draft-peabody-dispatch-new-uuid-format#name-uuid-version-7>).
 
 Memory layout:
 ```text
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                           unix_ts_ms                          |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |          unix_ts_ms           |  ver  |       rand_a          |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |var|                        rand_b                             |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                            rand_b                             |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 ``` */
public struct UUIDv7 : RawRepresentable {
	
	public private(set) var tsMsPart1: UInt8
	public private(set) var tsMsPart2: UInt8
	public private(set) var tsMsPart3: UInt8
	public private(set) var tsMsPart4: UInt8
	public private(set) var tsMsPart5: UInt8
	public private(set) var tsMsPart6: UInt8
	
	public private(set) var randAPart1: UInt8
	public private(set) var randAPart2: UInt8
	
	public private(set) var randBPart1: UInt8
	public private(set) var randBPart2: UInt8
	public private(set) var randBPart3: UInt8
	public private(set) var randBPart4: UInt8
	public private(set) var randBPart5: UInt8
	public private(set) var randBPart6: UInt8
	public private(set) var randBPart7: UInt8
	public private(set) var randBPart8: UInt8
	
	/**
	 Create a UUIDv7 with the given date and a possible random delta on the given date.
	 
	 The random bits are filled with random values.
	 
	 By default a UUID representing the current date exactly is created.
	 
	 - Important: Due to the limitation on the number of bytes dedicated to store the timestamp in the UUID,
	  it is possible for the UUID to represent another date than the one passed here (including the delta).
	 This is considered normal.
	 
	 - parameter allowedDateDelta: The maximum random delta allowed from the given date, or `nil` if no delta is allowed.
	 Creating a UUID representing the exact current date can be a security issue in some cases, so you can add a random delta automatically. */
	public init(date: Date = Date(), allowedDateDelta: TimeInterval? = nil) {
		/* We take the abs because we want to use the full 48 bits of the date and not have one bit for a sign that will always be 0. */
		let intervalFromEpoch = abs((date.timeIntervalSince1970 + (allowedDateDelta.flatMap{ d in TimeInterval.random(in: (-d)...(d)) } ?? 0)) * 1_000)
		guard intervalFromEpoch.exponent < 64 else {
			/* The interval is big.
			 * Probably too big to fit in an UInt64 big big…
			 * To do things well, we’d have to use some kind of BigInt lib (e.g. <https://github.com/mkrd/Swift-BigInt>)
			 *  and truncate the bits we can use (the 48 least significant bits).
			 * There might be better solutions I don’t know about too, of course.
			 * For now I’m not doing that; instead I just crash. */
			fatalError("Date is too far in the future (or the past) to be used. A later update of swift-typeid might add support for that. Open an issue if you need it.")
		}
		/* We convert the interval from epoch to an UInt64 and initialize our UUID with this value.
		 * Note: As we get a TimeInterval (aka. a Double) from Foundation, we have very low precision for dates far in the future or in the past.
		 * There probably are lowerer-level APIs that give access to more precision that we should use. */
		self.init(millisecondsTimestamp: UInt64(intervalFromEpoch))
	}
	
	/**
	 Create a UUIDv7 with the given timestamp.
	 
	 The random bits are filled with random values.
	 
	 - Important: As per the UUIDv7 specs, the timestamp value is truncated and only the 48 least-significant bits are kept. */
	public init(millisecondsTimestamp: UInt64) {
		(self.tsMsPart1, self.tsMsPart2, self.tsMsPart3, self.tsMsPart4, self.tsMsPart5, self.tsMsPart6) = withUnsafeBytes(of: millisecondsTimestamp.bigEndian, { bytes in
			/* We only keep the 48 least-significant bits as per the specs, so we skip the first two bytes. */
			return (
				bytes.load(fromByteOffset: 2, as: UInt8.self),
				bytes.load(fromByteOffset: 3, as: UInt8.self),
				bytes.load(fromByteOffset: 4, as: UInt8.self),
				bytes.load(fromByteOffset: 5, as: UInt8.self),
				bytes.load(fromByteOffset: 6, as: UInt8.self),
				bytes.load(fromByteOffset: 7, as: UInt8.self)
			)
		})
		self.randAPart1 = .random(in: 0...0b0000_1111)
		self.randAPart2 = .random(in: 0...UInt8.max)
		self.randBPart1 = .random(in: 0...0b0011_1111)
		self.randBPart2 = .random(in: 0...UInt8.max)
		self.randBPart3 = .random(in: 0...UInt8.max)
		self.randBPart4 = .random(in: 0...UInt8.max)
		self.randBPart5 = .random(in: 0...UInt8.max)
		self.randBPart6 = .random(in: 0...UInt8.max)
		self.randBPart7 = .random(in: 0...UInt8.max)
		self.randBPart8 = .random(in: 0...UInt8.max)
	}
	
	public init?(rawValue: UUID) {
		guard (rawValue.uuid.6 & 0b1111_0000) == 0b0111_0000,
				(rawValue.uuid.8 & 0b1100_0000) == 0b1000_0000
		else {
			/* We did not get a valid UUIDv7 UUID. */
			return nil
		}
		self.tsMsPart1  = rawValue.uuid.0
		self.tsMsPart2  = rawValue.uuid.1
		self.tsMsPart3  = rawValue.uuid.2
		self.tsMsPart4  = rawValue.uuid.3
		self.tsMsPart5  = rawValue.uuid.4
		self.tsMsPart6  = rawValue.uuid.5
		self.randAPart1 = rawValue.uuid.6 & 0b0000_1111
		self.randAPart2 = rawValue.uuid.7
		self.randBPart1 = rawValue.uuid.8 & 0b0011_1111
		self.randBPart2 = rawValue.uuid.9
		self.randBPart3 = rawValue.uuid.10
		self.randBPart4 = rawValue.uuid.11
		self.randBPart5 = rawValue.uuid.12
		self.randBPart6 = rawValue.uuid.13
		self.randBPart7 = rawValue.uuid.14
		self.randBPart8 = rawValue.uuid.15
	}
	
	public var rawValue: UUID {
		assert((randAPart1 & 0b1111_0000) == 0)
		assert((randBPart1 & 0b1100_0000) == 0)
		return UUID(uuid: (
			tsMsPart1,
			tsMsPart2,
			tsMsPart3,
			tsMsPart4,
			tsMsPart5,
			tsMsPart6,
			0b0111_0000 | randAPart1, /* randAPart1 is verified to be 0 for its first four bits. */
			randAPart2,
			0b1000_0000 | randBPart1, /* randBPart1 is verified to be 0 for its first two bits. */
			randBPart2,
			randBPart3,
			randBPart4,
			randBPart5,
			randBPart6,
			randBPart7,
			randBPart8
		))
	}
	
	/**
	 The timestamp for the UUID.
	 
	 This value is encoded in 48 bits in the UUID, it will never go higher than 2^48-1.
	 It will also never be negative (not in RFC, but true for this implementation of UUIDv7).
	 
	 The maximum date represented by this value will be: `10889-08-02 05:31:50 UTC`. */
	var unixTimestampInMilliseconds: Int64 {
		return Int64(bigEndian:
			(Int64(tsMsPart1) << 40) +
			(Int64(tsMsPart2) << 32) +
			(Int64(tsMsPart3) << 24) +
			(Int64(tsMsPart4) << 16) +
			(Int64(tsMsPart5) <<  8) +
			(Int64(tsMsPart6) <<  0)
		)
	}
	
	var date: Date {
		Date(timeIntervalSince1970: TimeInterval(unixTimestampInMilliseconds) / 1000)
	}
	
}
