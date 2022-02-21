import SwiftUI
import ComposableArchitecture
import Models
import Combine
import NetworkClient
import SwiftUIHelper
import SearchBarFeature

public struct AirportStationsClient {
	public var airports: () -> Effect<Airport, AirportsError>

	public init(airports: @escaping () -> Effect<Airport, AirportsError>) {
		self.airports = airports
	}
}

extension AirportStationsClient {
	public static var live: AirportStationsClient = .init(
		airports: {
			guard let request = NetworkClient.shared.makeAirpotStationsRequest() else {
				return Effect(value: Airport())
			}

			return URLSession.shared.dataTaskPublisher(for: request)
				.assumeHTTP()
				.responseData()
				.decoding(Airport.self, decoder: JSONDecoder())
				.catch { (error: AirportsError) -> AnyPublisher<Airport, AirportsError> in
					return Fail(error: error).eraseToAnyPublisher()
				}
				.receive(on: DispatchQueue.main)
				.eraseToEffect()
		}
	)

	public static var mock: AirportStationsClient = .init(
		airports: {
			Effect(value: Airport.mock)
				.eraseToEffect()
		}
	)
}

public enum AirportStationsAction: Equatable {
	case onAppear
	case station(id: Station.ID, action: StationAction)
	case station(_ station: Station, _ od: OD)
	case presentationMode(isDismiss: Bool)
	case searchBar(SearchBarAction)
	case airportStationResponse(Result<Airport, AirportsError>)
	case filterText(String)
}

public struct AirportStationsState: Equatable, Hashable {

	var airportStations: IdentifiedArrayOf<Station> = []
	var isLoading: Bool = false
	var presentationModeIsDismiss: Bool = false
	var searchBarState: SearchBarState = .init()
	var od: OD = .origin

	var filterAirportStations: IdentifiedArrayOf<Station> {
		self.airportStations
			.filter { $0.matches(self.searchBarState.searchText) }
	}

	public init(airportStations: IdentifiedArrayOf<Station> = [],
				isLoading: Bool = false,
				presentationModeIsDismiss: Bool = false,
				searchBarState: SearchBarState = .init(),
				od: OD = .origin) {
		self.airportStations = airportStations
		self.isLoading = isLoading
		self.presentationModeIsDismiss = presentationModeIsDismiss
		self.searchBarState = searchBarState
		self.od = od
	}
}

extension AirportStationsState {
	static public var mock: AirportStationsState = .init(
		airportStations: [Station.mockRussia, Station.mockFinland], isLoading: false
	)
}

public struct AirportStationsEnvironment {
	public var mainQueue: AnySchedulerOf<DispatchQueue>
	public var airportStationsClient: AirportStationsClient
}

extension AirportStationsEnvironment {
	static public var live: AirportStationsEnvironment = .init(
		mainQueue: .main,
		airportStationsClient: .live
	)

	static public var mock: AirportStationsEnvironment = .init(mainQueue: .immediate, airportStationsClient: .mock)
}

public let airportStationsReducer = Reducer<AirportStationsState, AirportStationsAction, AirportStationsEnvironment>.combine(
	searchBarReducer.pullback(
		state: \AirportStationsState.searchBarState,
		action: /AirportStationsAction.searchBar,
		environment: { _ in () }
	), .init { state, action, environment in
	switch action {
	case .onAppear:
		state.isLoading = true
		return environment.airportStationsClient
			.airports()
			.receive(on: environment.mainQueue)
			.catchToEffect()
			.map(AirportStationsAction.airportStationResponse)

	case let .airportStationResponse(.success(responseData)):
		state.isLoading = false
		state.airportStations = .init(uniqueElements: responseData.stations)

		print(#line, state.airportStations.map { $0.code }.count )
		return .none
	case let .airportStationResponse(.failure(error)):
		// handle error
		return .none
	case .presentationMode(isDismiss: let isDismiss):
		return .none

	case let .searchBar(.setIsEditing(bool)):
		state.searchBarState.isEditing = bool
		return .none

	case let .searchBar(.searchQueryChanged(searchString)):
		struct SearchId: Hashable {}
		return Effect(value: searchString)
			.debounce(id: SearchId(), for: 0.5, scheduler: environment.mainQueue)
			.map(AirportStationsAction.filterText)

	case let .filterText(finalSearchTring):
		state.searchBarState.searchText = finalSearchTring
		return .none

	case .station:
		return .none

	case .searchBar:
		return .none
	}
}
)

public struct AirportStationsView: View {

	@State private var searchString = ""
	@Environment(\.presentationMode) var presentationMode
	let store: Store<AirportStationsState, AirportStationsAction>

	public init(store: Store<AirportStationsState, AirportStationsAction>) {
		self.store = store
	}

    public var body: some View {
		WithViewStore(self.store) { viewStore in

			ScrollView {
				VStack {

					HStack {
						Button {
							viewStore.send(.presentationMode(isDismiss: true))
						} label: {
							Image(systemName: "xmark.circle")
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.horizontal)
					}

					Text("Select your \(viewStore.od.rawValue.capitalized)")

					SearchBarView(
						store: self.store.scope(
							state: \.searchBarState,
							action: AirportStationsAction.searchBar
						)
					)

					StationListView(
						store: viewStore.isLoading
						? Store(initialState: .mock, reducer: .empty, environment: ())
						: self.store
					)
				}
			}
			.onAppear {
				viewStore.send(.onAppear)
			}
		}
    }
}

struct AirportStationsView_Previews: PreviewProvider {
    static var previews: some View {
		AirportStationsView(
			store: Store(
				initialState: AirportStationsState.mock,
				reducer: airportStationsReducer,
				environment: AirportStationsEnvironment.mock
			)
		)
    }
}

struct StationListView: View {
	let store: Store<AirportStationsState, AirportStationsAction>

	var body: some View {
		WithViewStore(self.store) { viewStore in
			ForEachStore(
				self.store.scope(
					state: viewStore.state.searchBarState.isEditing
					? \.filterAirportStations
					: \.airportStations,
					action: AirportStationsAction.station
				)
			) { stationStore in
				WithViewStore(stationStore) { staionViewStore in
					Button {
						viewStore.send(.station(staionViewStore.state, viewStore.od))
					} label: {
						StationRowView(store: stationStore)
					}
				}
			}
		}
	}
}

public enum StationAction: Equatable {

}

var stationReducer = Reducer<Station, StationAction, Void> { state, action, _ in
	switch action {

	}
}

struct StationRowView: View {

	let store: Store<Station, StationAction>

	var body: some View {
		WithViewStore(self.store) { station in
			HStack {
				VStack {
					HStack {
						Text(station.name).font(.body)
							.frame(maxWidth: .infinity, alignment: .leading)

						Text(station.code)
							.foregroundColor(Color.blue)
					}

					Text(station.countryName).font(.body)
						.foregroundColor(Color.gray)
						.frame(maxWidth: .infinity, alignment: .leading)


					Divider()
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding()
			}
      .frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}

//struct StationRowView_Previews: PreviewProvider {
//	static var previews: some View {
//		StationRowView(
//			store: Store(
//				initialState: Station.mockRussia,
//				reducer: stationReducer,
//				environment: ()
//			)
//		)
//	}
//}
