// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RyanairSPM",
	platforms: [.iOS(.v14)],
	products: [
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "SearchFeature", targets: ["SearchFeature"]),
		.library(name: "SearchClient", targets: ["SearchClient"]),
		.library(name: "SearchBarFeature", targets: ["SearchBarFeature"]),
		.library(name: "SelectFlightFeature", targets: ["SelectFlightFeature"]),
		.library(name: "AirportStationFeature", targets: ["AirportStationFeature"]),
		.library(name: "DepartureFeature", targets: ["DepartureFeature"]),
		.library(name: "PassengerFeature", targets: ["PassengerFeature"]),
		.library(name: "Models", targets: ["Models"]),
		.library(name: "NetworkClient", targets: ["NetworkClient"]),
		.library(name: "SwiftUIHelper", targets: ["SwiftUIHelper"])
	],

	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.33.1")
	],

	targets: [
		.target(
			name: "AppFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"SearchFeature"
			]
		),

		.target(
			name: "SearchFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"Models", "NetworkClient", "SwiftUIHelper", "SearchClient",
				"AirportStationFeature", "PassengerFeature", "SearchBarFeature",
				"SelectFlightFeature"
			]
		),
		.testTarget(name: "SearchFeatureTests", dependencies: ["SearchFeature"]),

		.target(
			name: "SearchBarFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"Models",
			]
		),

		.target(
			name: "SelectFlightFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"Models",
			]
		),

		.target(
			name: "SearchClient",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"Models", "NetworkClient", "SwiftUIHelper"
			]
		),

		.target(
			name: "AirportStationFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"Models", "NetworkClient", "SwiftUIHelper", "SearchBarFeature"
			]
		),

		.target(
			name: "DepartureFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),

		.target(
			name: "PassengerFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"SwiftUIHelper"
			]
		),

		.target(
			name: "Models",
			resources: [.process("Resources/")]
		),
		.target(name: "NetworkClient", dependencies: ["Models"]),
		.target(name: "SwiftUIHelper", dependencies: ["Models"])

	]
)
