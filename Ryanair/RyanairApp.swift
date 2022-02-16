//
//  RyanairApp.swift
//  Ryanair
//
//  Created by Saroar Khandoker on 09.02.2022.
//

import SwiftUI
import AppFeature
import ComposableArchitecture

@main
struct RyanairApp: App {
	let store: Store<AppState, AppAction> = Store(
		initialState: .init(),
		reducer: appReducer,
		environment: .live
	)

	var body: some Scene {
		WindowGroup {
			AppView(store: store)
		}
	}
}
