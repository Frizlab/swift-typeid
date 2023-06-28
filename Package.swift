// swift-tools-version: 5.5
import PackageDescription


let package = Package(
	name: "swift-typeid",
	products: [
		.library(name: "TypeID", targets: ["TypeID"]),
	],
	targets: [
		.target(name: "TypeID", path: "Sources"),
		.testTarget(name: "TypeIDTests", dependencies: ["TypeID"], path: "Tests"),
	]
)
