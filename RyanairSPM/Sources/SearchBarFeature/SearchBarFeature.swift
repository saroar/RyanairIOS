import SwiftUI
import ComposableArchitecture
import Models

struct SearchBarClient {}

public struct SearchBarState: Equatable, Hashable {
	public init(
		searchText: String = "",
		isEditing: Bool = false
	) {
		self.searchText = searchText
		self.isEditing = isEditing
	}

	public var searchText: String = ""
	public var isEditing = false

}


extension SearchBarState {
	static public let mockWithsearchBarStateTrue: SearchBarState = .init(
		isEditing: true
	)

	static public let mockWithsearchBarStateFalse: SearchBarState = .init()

	static public let mockWithsearchBarStateTrueWithSearchText: SearchBarState = .init(
		searchText: "super",
		isEditing: true
	)
}

public enum SearchBarAction: Hashable {
	case onAppear
	case setIsEditing(Bool)
	case isSortingViewIsActive
	case searchQueryChanged(String)
}

public let searchBarReducer = Reducer<SearchBarState, SearchBarAction, Void>  { state, action, _ in
	switch action {

	case .onAppear:
		return .none
	case let .setIsEditing(bool):
		
		return .none

	case .isSortingViewIsActive:
		return .none

	case let .searchQueryChanged(query):
		
		return .none

	}
}

public struct SearchBarView: View {

	struct ViewState: Equatable {

		init(state: SearchBarState) {
			self.searchText = state.searchText
			self.isEditing = state.isEditing
		}

		let searchText: String
		let isEditing: Bool

	}

	let store: Store<SearchBarState, SearchBarAction>

	public init(store: Store<SearchBarState, SearchBarAction>) {
		self.store = store
	}

	public var body: some View {

		WithViewStore(store.scope(state: ViewState.init)) { viewStore in
			ZStack {
				HStack {
					TextField(
						"Search",
						text: viewStore.binding(
							get: \.searchText,
							send: SearchBarAction.searchQueryChanged
						)
					)
					.frame(height: 46)
					.padding(.vertical, 5)
					.padding(.horizontal, 40)
					.background(Color(.systemGray6))
					.cornerRadius(100)
					.overlay(
						HStack {
							Image(systemName: "magnifyingglass")
								.foregroundColor(.gray)
								.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
								.padding(.leading, 14)
						}
					)
					.padding(.horizontal, 10)
					.onTapGesture {
						withAnimation {
							viewStore.send(.setIsEditing(true))
						}
					}

					Button {

					} label: {
						if viewStore.isEditing {
							Button(
								action: {
									withAnimation {
										viewStore.send(.searchQueryChanged(""))
										viewStore.send(.setIsEditing(false))
									}
								}
							) {
								Text("Cancel")
									.padding(.trailing)
							}
						}
					}

				}
			}
		}

	}
}

struct SearchBarView_Previews: PreviewProvider {

	static var previews: some View {
		let store = Store(
			initialState: SearchBarState.mockWithsearchBarStateTrueWithSearchText,
			reducer: searchBarReducer,
			environment: ()
		)
		SearchBarView(store: store)
	}
}
