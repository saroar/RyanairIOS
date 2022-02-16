import SwiftUI
import ComposableArchitecture
import Models
import SwiftUIHelper

public struct PassengerState: Equatable, Hashable {
	public var passengers: [Passenger] = Passenger.passengers

	public init() {}
}

public enum PassengerAction: Equatable {
	case passengers(Passenger, PlusMinus)
	case presentationModeDismiss

	public enum PlusMinus: String {
		case plus
		case minus
	}
}


public let passengerReducer = Reducer<PassengerState, PassengerAction, Void> { state, action, _ in
	switch action {

	case let .passengers(person, countEnum):
		return .none
	case .presentationModeDismiss:
		return .none
	}
}

public struct PassengerView: View {

	let store: Store<PassengerState, PassengerAction>

	public init(store: Store<PassengerState, PassengerAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store) { viewStore in

			VStack {

				ForEach(viewStore.passengers, id: \.self) { passenger in

					HStack {

						VStack {
							Text(passenger.passenger.rawValue)
								.font(.title)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(passenger.subTitle)
								.font(.body)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						.frame(maxWidth: .infinity, alignment: .leading)

						Spacer()

						Button {
							viewStore.send(.passengers(passenger, .minus))
						} label: {
							Image(systemName: "minus.circle")
								.font(.title)

						}

						Text("\(passenger.count)")
							.font(.title).bold()

						Button {
							viewStore.send(.passengers(passenger, .plus))
						} label: {
							Image(systemName: "plus.circle")
								.font(.title)
						}
					}
					.padding()
				}

				HStack {
					Button {
						viewStore.send(.presentationModeDismiss)
					} label: {
						Image(systemName: "xmark")
							.font(.title)
					}
				}
				.padding()

			}
			.padding()
			.frame(maxWidth: .infinity, alignment: .center)
			.background(Color(UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)))
			.cornerRadius(20, corners: [.topLeft, .topRight])
			.transition(.slide)
		}

	}
}

struct PassengerView_Previews: PreviewProvider {
    static var previews: some View {
		PassengerView(
			store: Store(
				initialState: PassengerState(),
				reducer: passengerReducer,
				environment: ()
			)
		)
    }
}
