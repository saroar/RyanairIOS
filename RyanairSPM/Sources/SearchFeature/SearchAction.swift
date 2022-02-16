import SwiftUI
import ComposableArchitecture
import Models
import AirportStationFeature
import PassengerFeature
import SelectFlightFeature

public enum SearchAction: Equatable {

	case onApper
	case selectedTripTypeTab(TripType)
	case setSheet(isPresented: Bool, od: OD)
	case setSelectedDateViewFromSheet(isPresented: Bool)
	case setSelectedDateViewToSheet(isPresented: Bool)
	case setPassengerViewSheet(isPresented: Bool)
	case airportAction(AirportStationsAction)
	case seletedDateAction(SelectFlightAction)
	case passengersAction(PassengerAction)
	case findTicketButtonTapped

	case ticketAvailabilityResponse(Result<Departure, AirportsError>)
}
