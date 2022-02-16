import SwiftUI
import Models
import ComposableArchitecture

public struct DepartureState: Equatable, Hashable {
	public var departure: Departure

	public var trips: IdentifiedArrayOf<Trip> {
		return .init(uniqueElements: departure.trips)
	}

//	public var dates: IdentifiedArrayOf<DateElement> {
//		return .init(uniqueElements: trips)
//	}
//
//	public var flights: IdentifiedArrayOf<Flight> {
//		return .init(uniqueElements: trips.filter { $0 } )
//	}

}

public enum DepartureAction {}

public let departureReducer = Reducer<DepartureState, DepartureAction, Void> { state, action, _ in
	switch action {}
}

struct DepartureView: View {

	@Environment(\.presentationMode) var presentationMode

	let store: Store<DepartureState, DepartureAction>

	init(store: Store<DepartureState, DepartureAction>) {
		self.store = store
	}

	var body: some View {
		WithViewStore(self.store) { viewStore in
			VStack {
			HStack {
				Button {
					presentationMode.wrappedValue.dismiss()
				} label: {
					Image(systemName: "xmark")
						.font(.title)
						.foregroundColor(Color.white)
				}

				Spacer()
				//.frame(maxWidth: .infinity, alignment: .leading)

				VStack {

					HStack {
						Text("\(viewStore.departure.trips[0].origin)")
						.font(.title).bold()
						.foregroundColor(Color.white)

						Image(systemName: "arrow.right")
							.foregroundColor(Color.white)
							.font(.title)

						Text("\(viewStore.departure.trips[0].destination)")
						.font(.title).bold()
						.foregroundColor(Color.white)
					}
					.frame(maxWidth: .infinity, alignment: .center)

					Text("Departure")
						.font(.body).bold()
						.foregroundColor(Color.white)
						.frame(maxWidth: .infinity, alignment: .center)
				}
			}
			.padding()
			.background(Color.blue)
			.frame(maxWidth: .infinity, alignment: .center)

//			ForEach(viewStore.flights.trips, id: \.self) { trip in
//				Text(trip.originName)
//
//				HStack {
//					Text(trip.origin)
//				}
//			}

			Spacer()

		}
		}
    }
}

struct DepartureViewView_Previews: PreviewProvider {
    static var previews: some View {
		DepartureView(
			store: Store(
				initialState: DepartureState(departure: .mock),
				reducer: departureReducer,
				environment: ()
			)
		)
    }
}
