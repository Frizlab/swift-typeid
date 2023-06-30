/*
 * UUID+Base32.swift
 * TypeID
 *
 * Created by François Lamboley on 2023/06/29.
 * Conversion and adaptation of <https://github.com/jetpack-io/typeid-go/blob/eb881e3ce4e3e6206cfd92a03832f374e58decf6/base32/base32.go> in Swift.
 */

import Foundation



extension UUID {
	
	public init?(base32EncodedString str: String) {
		/* First check: If the string is not exactly 26 char, it does not represent a UUID. */
		guard str.count == 26 else {return nil}
		
		let values = str.compactMap{ lookupTable[$0] }
		/* Second check: It’s not because the string was 26 chars that all its characters were valid in a base32 encoded UUID. */
		guard values.count == 26 else {return nil}
		
		var data = Data(repeating: 0, count: 16)
		data[0]  = (values[0]  << 5) |  values[1]
		data[1]  = (values[2]  << 3) | (values[3] >> 2)
		data[2]  = (values[3]  << 6) | (values[4] << 1) | (values[5] >> 4)
		data[3]  = (values[5]  << 4) | (values[6] >> 1)
		data[4]  = (values[6]  << 7) | (values[7] << 2) | (values[8] >> 3)
		data[5]  = (values[8]  << 5) |  values[9]
		data[6]  = (values[10] << 3) | (values[11] >> 2)
		data[7]  = (values[11] << 6) | (values[12] << 1) | (values[13] >> 4)
		data[8]  = (values[13] << 4) | (values[14] >> 1)
		data[9]  = (values[14] << 7) | (values[15] << 2) | (values[16] >> 3)
		data[10] = (values[16] << 5) |  values[17]
		data[11] = (values[18] << 3) | (values[19] >> 2)
		data[12] = (values[19] << 6) | (values[20] << 1) | (values[21] >> 4)
		data[13] = (values[21] << 4) | (values[22] >> 1)
		data[14] = (values[22] << 7) | (values[23] << 2) | (values[24] >> 3)
		data[15] = (values[24] << 5) |  values[25]
		self.init(data: data)
	}
	
	public func base32EncodedString() -> String {
		let data = data
		/* Optimized unrolled loop. */
		let char0  = alphabet[Int( (data[0]  & 224) >> 5)]
		let char1  = alphabet[Int(  data[0]  & 31)]
		let char2  = alphabet[Int( (data[1]  & 248) >> 3)]
		let char3  = alphabet[Int(((data[1]  & 7)   << 2) | ((data[2]  & 192) >> 6))]
		let char4  = alphabet[Int( (data[2]  & 62)  >> 1)]
		let char5  = alphabet[Int(((data[2]  & 1)   << 4) | ((data[3]  & 240) >> 4))]
		let char6  = alphabet[Int(((data[3]  & 15)  << 1) | ((data[4]  & 128) >> 7))]
		let char7  = alphabet[Int( (data[4]  & 124) >> 2)]
		let char8  = alphabet[Int(((data[4]  & 3)   << 3) | ((data[5]  & 224) >> 5))]
		let char9  = alphabet[Int(  data[5]  & 31)]
		let char10 = alphabet[Int( (data[6]  & 248) >> 3)]
		let char11 = alphabet[Int(((data[6]  & 7)   << 2) | ((data[7]  & 192) >> 6))]
		let char12 = alphabet[Int( (data[7]  & 62)  >> 1)]
		let char13 = alphabet[Int(((data[7]  & 1)   << 4) | ((data[8]  & 240) >> 4))]
		let char14 = alphabet[Int(((data[8]  & 15)  << 1) | ((data[9]  & 128) >> 7))]
		let char15 = alphabet[Int( (data[9]  & 124) >> 2)]
		let char16 = alphabet[Int(((data[9]  & 3)   << 3) | ((data[10] & 224) >> 5))]
		let char17 = alphabet[Int(  data[10] & 31)]
		let char18 = alphabet[Int( (data[11] & 248) >> 3)]
		let char19 = alphabet[Int(((data[11] & 7)   << 2) | ((data[12] & 192) >> 6))]
		let char20 = alphabet[Int( (data[12] & 62)  >> 1)]
		let char21 = alphabet[Int(((data[12] & 1)   << 4) | ((data[13] & 240) >> 4))]
		let char22 = alphabet[Int(((data[13] & 15)  << 1) | ((data[14] & 128) >> 7))]
		let char23 = alphabet[Int( (data[14] & 124) >> 2)]
		let char24 = alphabet[Int(((data[14] & 3)   << 3) | ((data[15] & 224) >> 5))]
		let char25 = alphabet[Int(  data[15] & 31)]
		return String([
			char0,  char1,  char2,  char3,  char4,  char5,  char6,  char7,  char8,  char9,  char10, char11, char12,
			char13, char14, char15, char16, char17, char18, char19, char20, char21, char22, char23, char24, char25,
		])
	}
	
	internal init?(data: Data) {
		guard data.count == 16 else {
			return nil
		}
		self.init(uuid: (
			data[0],  data[1],  data[2],  data[3],
			data[4],  data[5],  data[6],  data[7],
			data[8],  data[9],  data[10], data[11],
			data[12], data[13], data[14], data[15]
		))
	}
	
	internal var data: Data {
		let bytes = uuid
		return Data([
			bytes.0,  bytes.1,  bytes.2,  bytes.3,
			bytes.4,  bytes.5,  bytes.6,  bytes.7,
			bytes.8,  bytes.9,  bytes.10, bytes.11,
			bytes.12, bytes.13, bytes.14, bytes.15
		])
	}
	
}


private let alphabet: [Character] = [
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
	"a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m",
	"n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"
]

private let lookupTable: [Character: UInt8] = [
	"0": 0x00, "1": 0x01, "2": 0x02, "3": 0x03, "4": 0x04, "5": 0x05, "6": 0x06, "7": 0x07, "8": 0x08, "9": 0x09,
	/* The original implementation used to allow uppercase values in the base32 encoded UUID, but it does not anymore… */
//	"A": 0x0A, "B": 0x0B, "C": 0x0C, "D": 0x0D, "E": 0x0E, "F": 0x0F, "G": 0x10, "H": 0x11, "J": 0x12, "K": 0x13, "M": 0x14,
//	"N": 0x15, "P": 0x16, "Q": 0x17, "R": 0x18, "S": 0x19, "T": 0x1A, "V": 0x1B, "W": 0x1C, "X": 0x1D, "Y": 0x1E, "Z": 0x1F,
	"a": 0x0A, "b": 0x0B, "c": 0x0C, "d": 0x0D, "e": 0x0E, "f": 0x0F, "g": 0x10, "h": 0x11, "j": 0x12, "k": 0x13, "m": 0x14,
	"n": 0x15, "p": 0x16, "q": 0x17, "r": 0x18, "s": 0x19, "t": 0x1A, "v": 0x1B, "w": 0x1C, "x": 0x1D, "y": 0x1E, "z": 0x1F
]
