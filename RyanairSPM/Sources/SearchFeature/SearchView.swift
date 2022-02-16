import SwiftUI
import ComposableArchitecture
import Models
import SearchClient
import AirportStationFeature
import PassengerFeature
import SelectFlightFeature

public struct SearchView: View {

	let store: Store<SearchState, SearchAction>

	public init(store: Store<SearchState, SearchAction>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store) { viewStore in
			ZStack(alignment: .bottom) {
				VStack {
					Text("Find Flights")
						.font(.title).bold()

					Picker(
						"Trip",
						selection: viewStore.binding(
							get: \.currentTripTab,
							send: SearchAction.selectedTripTypeTab
						)
							.animation()
					) {
						ForEach(TripType.allCases, id: \.self) {
							Text($0.rawValue)
								.tag($0)
						}
					}
					.pickerStyle(.segmented)
					.padding()

					VStack {
						VStack {
							Text("From")
								.font(.body)
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(.vertical, 5)

							HStack {
								Button {
									viewStore.send(.setSheet(isPresented: true, od: .origin))
								} label: {
									HStack {
										Image(systemName: "location.fill")
										Text(viewStore.fromAirportStationName)
											.font(.body).bold()
											.frame(maxWidth: .infinity, alignment: .leading)

									}
								}
								Text(viewStore.fromAirportStationCode).bold()
							}
						}
						.padding()

						Divider()
							.padding(.horizontal)

						VStack {
							Text("To")
								.font(.body)
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(.vertical, 5)

							HStack {
								Button {
									viewStore.send(
										.setSheet(isPresented: true, od: .destination)
									)
								} label: {
									HStack {
										Image(systemName: "location.fill")
										Text(viewStore.toAirportStationName)
											.font(.body).bold()
											.frame(maxWidth: .infinity, alignment: .leading)

									}
								}
								Text(viewStore.toAirportStationCode).bold()
							}
						}
						.padding()

					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.border(Color.gray)
					.padding()

					HStack {
						VStack {
							Text("Fly Out")
								.padding(.vertical, 3)
								.frame(maxWidth: .infinity, alignment: .leading)
							Button {
								viewStore.send(.setSelectedDateViewFromSheet(isPresented: true))
							} label: {
								Text(viewStore.queryParams.dateout.isEmpty
									 ? "Select Date"
									 : "\(viewStore.queryParams.dateout)"
								)
									.frame(maxWidth: .infinity, alignment: .leading)

							}
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)

						Divider()
							.frame(height: 50)


						VStack {
							Text("Fly Back")
								.padding(.vertical, 3)
								.frame(maxWidth: .infinity, alignment: .leading)
							Button {
								viewStore.send(.setSelectedDateViewToSheet(isPresented: true))
							} label: {
								Text("Select Date")
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
						.disabled(!viewStore.isRoundTrip)
						.foregroundColor(!viewStore.isRoundTrip ? Color.gray : nil)


					}
					.frame(maxWidth: .infinity, alignment: .center)
					.border(Color.gray)
					.padding()

					VStack {
						Text("Passengers")
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.vertical, 1)

						Button {
							viewStore.send(.setPassengerViewSheet(isPresented: true))
						} label: {
							Text(viewStore.passengersStringValue)
								.font(.body).bold()
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
					.padding()
					.border(Color.gray)
					.padding()

					if let departure = viewStore.departure {
						VStack {
							HStack {
								Text("\(departure.trips[0].origin)")
									.font(.title).bold()

								Image(systemName: "arrow.right")
									.font(.title)

								Text("\(departure.trips[0].destination)")
									.font(.title).bold()
							}
							.frame(maxWidth: .infinity, alignment: .center)

						}
					} else {
						ProgressView()
							.opacity(viewStore.isLoading ? 1 : 0)
					}

					Spacer()

					Button {
						viewStore.send(.findTicketButtonTapped)
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
					.opacity(viewStore.queryParams.isValid ? 1 : 0)


				}
				.fullScreenCoverCompat(
					isPresented: viewStore.binding(
						get: \.isSheetPresented.0,
						send: { SearchAction.setSheet(isPresented: $0, od: .origin) }
					)
				) {
					IfLetStore(
						self.store.scope(
							state: \.airportStationState,
							action: SearchAction.airportAction
						),
						then: AirportStationsView.init(store:)
					)
				}
				.fullScreenCoverCompat(
					isPresented: viewStore.binding(
						get: \.isSelectedDateSheetPresented,
						send: SearchAction.setSelectedDateViewToSheet(isPresented:)
					)
				) {
					IfLetStore(
						self.store.scope(
							state: \.seletedDateState,
							action: SearchAction.seletedDateAction
						),
						then: SelectFlightView.init(store:)
					)
				}

				IfLetStore(
					self.store.scope(
						state: \.passengerState,
						action: SearchAction.passengersAction
					),
					then: PassengerView.init(store:)
				)
				
			}
			.onAppear {
				viewStore.send(.onApper)
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {

	static var previews: some View {
		SearchView(
			store: Store(
				initialState: SearchState(),
				reducer: searchReducer,
				environment: .mock
			)
		)
	}
}


struct FullScreenCoverCompat<CoverContent: View>: ViewModifier {
	@Binding var isPresented: Bool
	let content: () -> CoverContent

	func body(content: Content) -> some View {
		GeometryReader { geo in
			ZStack {
				// this color makes sure that its enclosing ZStack
				// (and the GeometryReader) fill the entire screen,
				// allowing to know its full height
				Color.clear
				content
				ZStack {
					// the color is here for the cover to fill
					// the entire screen regardless of its content
					Color.white
					self.content()
				}
				.offset(y: isPresented ? 0 : geo.size.height)
				// feel free to play around with the animation speeds!
				.animation(.spring())
			}
		}
	}
}

extension View {
	func fullScreenCoverCompat<Content: View>(isPresented: Binding<Bool>,
											  content: @escaping () -> Content) -> some View {
		self.modifier(FullScreenCoverCompat(isPresented: isPresented,
											content: content))
	}
}
