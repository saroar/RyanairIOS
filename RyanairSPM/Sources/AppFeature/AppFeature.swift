import SwiftUI
import ComposableArchitecture
import SearchFeature

public struct AppState: Equatable {
	public init() {}

	public var searchState: SearchState = .init()
}
public enum AppAction {
	case search(SearchAction)
}

public struct AppEnvironment {
	public init() {}
}

extension AppEnvironment {
	static public let live: AppEnvironment = .init()
}

public var appReducer =
searchReducer.pullback(
	state: \.searchState,
	action: /AppAction.search,
	environment: { _ in SearchEnvironment.live }
).combined(with:  Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
	switch action {
	case .search(_):
		return .none
	}
}
)

public struct AppView: View {
	let store: Store<AppState, AppAction>

	public init(store: Store<AppState, AppAction>) {
		self.store = store
	}

	public var body: some View {
		ZStack {
			SearchView(
				store: self.store.scope(
					state: \.searchState,
					action: AppAction.search
				)
			)
		}
	}
}
