import SwiftUI
import ComposableArchitecture
import SwiftUIHelper

public enum SelectFlightAction: Equatable {
	case onApper
	case from(Date)
	case dismissView
}

public struct SelectFlightState: Equatable, Hashable {

	public var fromDate: Date = Date()
	public var isRoundTrip: Bool = false

	public init(fromDate: Date = Date(), isRoundTrip: Bool = false) {
		self.fromDate = fromDate
		self.isRoundTrip = isRoundTrip
	}
}


public let selectFlightReducer = Reducer<SelectFlightState, SelectFlightAction, Void> { state, action, _ in
	switch action {
	case .onApper:
		return .none

	case let .from(date):
		state.fromDate = date
		return .none
	case .dismissView:
		return .none
	}
}

public struct SelectFlightView: View {

	let store: Store<SelectFlightState, SelectFlightAction>

	public init(store: Store<SelectFlightState, SelectFlightAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store) { viewStore in
			VStack {

				HStack {
					Button {
						viewStore.send(.dismissView)
					} label: {
						Image(systemName: "xmark")
							.font(.title)
							.foregroundColor(Color.white)
					}
					.frame(maxWidth: .infinity, alignment: .leading)

					Text("Select your date")
						.font(.body).bold()
						.foregroundColor(Color.white)
				}
				.padding()
				.background(Color.blue)

				HStack {
					VStack {
						Text("Corfu")
						Text(" \(viewStore.fromDate.monthName) \(viewStore.fromDate.day)" )
							.foregroundColor(Color.blue)
					}
					.font(.body)

					Image(systemName: "airplane").font(.title)
						.padding()

					VStack {
						Text("Corfu")
						Text("")
					}

				}

				.frame(maxWidth: .infinity, alignment: .center)

				Divider()

				DatePicker("",
					selection: viewStore.binding(
						get: \.fromDate,
						send: SelectFlightAction.from
					),
					displayedComponents: [.date]
				)
				.datePickerStyle(.graphical)

				Spacer()

				Divider()
					.frame(height: 5)
					.foregroundColor(Color.gray)

				Button {
					viewStore.send(.from(viewStore.fromDate))
					viewStore.send(.dismissView)
				} label: {
					Text("Let's go")
						.font(.title).bold()
						.frame(maxWidth: .infinity, alignment: .center)
						.padding()
				}

				.background(Color.blue)
				.foregroundColor(.white)
				.clipShape(Capsule())
				.padding()
			}
		}
	}
}

struct SelectFlightView_Previews: PreviewProvider {
	static var previews: some View {
		SelectFlightView(
			store: Store(
				initialState: SelectFlightState(),
				reducer: selectFlightReducer,
				environment: ()
			)
		)
	}
}
