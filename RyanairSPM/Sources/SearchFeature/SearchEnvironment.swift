import SwiftUI
import ComposableArchitecture
import Models
import SearchClient

public struct SearchEnvironment {
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	public var searchClient: SearchClient
}

extension SearchEnvironment {
	static public var live: SearchEnvironment = .init(
		mainQueue: .main,
		searchClient: .live
	)

	static public var mock: SearchEnvironment = .init(
		mainQueue: .immediate,
		searchClient: .mock
	)
}
