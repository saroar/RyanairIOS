import SwiftUI
import ComposableArchitecture
import Combine
import Models

public struct SearchClient {

	public var search: (QueryParams) -> Effect<Departure, AirportsError>

	public init(
		search: @escaping (QueryParams) -> Effect<Departure, AirportsError>
	) {
		self.search = search
	}

}
