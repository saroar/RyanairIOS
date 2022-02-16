import SwiftUI
import ComposableArchitecture
import Combine
import Models
import NetworkClient
import SwiftUIHelper

extension SearchClient {
	public static var live: SearchClient = .init(
		search: { queryParams in
			guard let request = NetworkClient.shared.makeTicketAvailabilityRequest(query: queryParams) else {
				return Effect(value: Departure.mock)
			}

			return URLSession.shared.dataTaskPublisher(for: request)
				.assumeHTTP()
				.responseData()
				.decoding(Departure.self, decoder: JSONDecoder())
				.catch { (error: AirportsError) -> AnyPublisher<Departure, AirportsError> in
					return Fail(error: error).eraseToAnyPublisher()
				}
				.receive(on: DispatchQueue.main)
				.eraseToEffect()
		}
	)
}

extension SearchClient {
	public static var mock: SearchClient = .init(
		search: { _ in
			return Effect(value: Departure.departureFullMock)
				.eraseToEffect()
		}
	)

}
