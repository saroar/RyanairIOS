import ComposableArchitecture
import Models
import XCTest

@testable import SearchFeature

class SearchFeatureTests: XCTestCase {

	let scheduler = DispatchQueue.test

    func testSelectAirpotFromTo() {
		var state = SearchState.mock
		state.isLoading = true

		let store = TestStore(
			initialState: state,
			reducer: searchReducer,
			environment: SearchEnvironment(
				mainQueue: self.scheduler.eraseToAnyScheduler(),
				searchClient: .mock
			)
		)

		store.send(.findTicketButtonTapped)
		self.scheduler.advance(by: 1)
		store.receive(.ticketAvailabilityResponse(.success(.departureFullMock))) {
			$0.isLoading = false
		}

	}
}
































































