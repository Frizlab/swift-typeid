/*
 *  Helpers.swift
 * TypeIDTests
 *
 * Created by François Lamboley on 2022/12/22.
 */

import Foundation
import XCTest



public extension XCTestCase {
	
	static let testsDataPath = URL(fileURLWithPath: #file, isDirectory: false)
		.deletingLastPathComponent()
		.deletingLastPathComponent()
		.appendingPathComponent("TestsData", isDirectory: true)
//		.appending(path: "TestsData", directoryHint: .isDirectory) /* macOS 13+ */
	
}
