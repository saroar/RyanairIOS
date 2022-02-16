import SwiftUI
import ComposableArchitecture
import Models
import AirportStationFeature
import PassengerFeature
import SelectFlightFeature

public let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>.combine(
	airportStationsReducer
		.optional()
		.pullback(
			state: \SearchState.airportStationState,
			action: /SearchAction.airportAction,
			environment: { _ in AirportStationsEnvironment.live }
		),
	selectFlightReducer
		.optional()
		.pullback(
			state: \SearchState.seletedDateState,
			action: /SearchAction.seletedDateAction,
			environment: { _ in () }
		),
	passengerReducer
		.optional()
		.pullback(
			state: \SearchState.passengerState,
			action: /SearchAction.passengersAction,
			environment: { _ in () }
		),
	.init { state, action, environment in
		switch action {

		case .onApper:
			state.passengersStringValue = state.passengers
				.filter { $0.count > 0 }
				.map { "\($0 )"}
				.joined(separator: ", ")

			return .none

		case let .selectedTripTypeTab(tab):
			state.currentTripTab = tab
			return .none

		case .setSheet(isPresented: let isPresented):
			state.airportStationState = isPresented.0 ? AirportStationsState(od: isPresented.1) : nil

			return .none

		case .airportAction(.presentationMode(isDismiss: let isDismiss)):
			if isDismiss == true { state.airportStationState = nil }
			return .none

		case let .airportAction(.station(station, od)):

			if od == .origin {
				state.fromAirportStationName = "\(station.name)"
				state.fromAirportStationCode = "\(station.code)"

				state.queryParams.origin = station.code
			} else {
				state.toAirportStationName = "\(station.name)"
				state.toAirportStationCode = "\(station.code)"

				state.queryParams.destination = station.code
			}

			state.airportStationState = nil
			return .none

		case .airportAction:
			return .none

		case let .seletedDateAction(.from(date)):
			state.queryParams.dateout = date.toString

			return .none

		case .seletedDateAction(.dismissView):
			state.seletedDateState = nil
			return .none


		case .seletedDateAction:
			return .none

		case .setSelectedDateViewFromSheet(isPresented: let isPresented):
			state.seletedDateState = isPresented ? SelectFlightState(isRoundTrip: state.isRoundTrip) : nil
			return .none
		case .setSelectedDateViewToSheet(isPresented: let isPresented):
			state.seletedDateState = isPresented ? SelectFlightState(isRoundTrip: state.isRoundTrip) : nil
			return .none

		case .findTicketButtonTapped:

			print(#line, state.queryParams)
			if state.queryParams.isValid {
				state.isLoading = true
				return environment.searchClient.search(state.queryParams)
					.receive(on: environment.mainQueue)
					.catchToEffect()
					.map(SearchAction.ticketAvailabilityResponse)
			}

			return .none

		case let .ticketAvailabilityResponse(.success(departure)):
			print(#line, departure)
			state.departure = departure
			state.isLoading = false
			return .none

		case let .ticketAvailabilityResponse(.failure(error)):
			// handler error
			state.isLoading = false
			return .none

		case .setPassengerViewSheet(isPresented: let isPresented):
			state.passengerState = isPresented ? PassengerState() : nil
			return .none

		case let .passengersAction(.passengers(person, countEnum)):
			if let index = state.passengerState?.passengers.firstIndex(where: { $0 == person }) {
				guard var passenger = state.passengerState?.passengers[index] else {
					return .none
				}

				if countEnum == .plus {
					passenger.count += 1
				} else {
					passenger.count -= 1
				}

				state.passengerState?.passengers[index] = passenger
			}

			if let passengers = state.passengerState?.passengers {
				state.passengersStringValue = passengers
					.filter { $0.count > 0 }
					.map { "\($0 )"}
					.joined(separator: ", ")

				state.passengers = passengers
			}

			return .none

		case .passengersAction(.presentationModeDismiss):
			state.passengerState = nil
			return .none

		case .passengersAction:
			return .none

		}
	}
).debug()
