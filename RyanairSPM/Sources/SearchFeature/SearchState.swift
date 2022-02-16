import SwiftUI
import ComposableArchitecture
import Models
import AirportStationFeature
import PassengerFeature
import SelectFlightFeature

public struct SearchState: Equatable, Hashable {


	public var currentTripTab = TripType.oneWay
	public var airportStationState: AirportStationsState?
	public var isSheetPresented: (Bool, OD) { (self.airportStationState != nil, .origin) }

	public var seletedDateState: SelectFlightState?
	public var isSelectedDateSheetPresented: Bool { self.seletedDateState != nil }

	public var fromAirportStationName: String = "Where are you flying from?"
	public var toAirportStationName: String = "Where are you going?"

	public var fromAirportStationCode: String = ""
	public var toAirportStationCode: String = ""
	public var isRoundTrip: Bool { self.currentTripTab != TripType.oneWay }

	public var queryParams = QueryParams(origin: "", destination: "", dateout: "")

	public var departure: Departure? = nil
	public var isLoading: Bool = false

	public var passengerState: PassengerState?
	public var isPassengerSheetPresented: Bool { self.passengerState != nil }


	public var passengers: [Passenger] = Passenger.passengers
	public var passengersStringValue: String = ""

	public init(currentTripTab: TripType = TripType.oneWay, airportStationState: AirportStationsState? = nil, seletedDateState: SelectFlightState? = nil, fromAirportStationName: String = "Where are you flying from?", toAirportStationName: String = "Where are you going?", fromAirportStationCode: String = "", toAirportStationCode: String = "", queryParams: QueryParams = QueryParams(origin: "", destination: "", dateout: ""), departure: Departure? = nil, isLoading: Bool = false, passengerState: PassengerState? = nil, passengers: [Passenger] = Passenger.passengers, passengersStringValue: String = "") {
		self.currentTripTab = currentTripTab
		self.airportStationState = airportStationState
		self.seletedDateState = seletedDateState
		self.fromAirportStationName = fromAirportStationName
		self.toAirportStationName = toAirportStationName
		self.fromAirportStationCode = fromAirportStationCode
		self.toAirportStationCode = toAirportStationCode
		self.queryParams = queryParams
		self.departure = departure
		self.isLoading = isLoading
		self.passengerState = passengerState
		self.passengers = passengers
		self.passengersStringValue = passengersStringValue
	}
}

extension SearchState {
	static public var mock: SearchState = .init(
		currentTripTab: .oneWay,
		airportStationState: nil,
		seletedDateState: nil,
		fromAirportStationName: "",
		toAirportStationName: "",
		fromAirportStationCode: "",
		toAirportStationCode: "",
		queryParams: QueryParams.mockSTNtoLIS,
		departure: .departureFullMock,
		isLoading: false,
		passengerState: nil,
		passengers: Passenger.passengers,
		passengersStringValue: ""
	)
}
