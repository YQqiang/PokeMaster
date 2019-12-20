//
//  Store.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
    @Published var appState: AppState = AppState()

    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]:\(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result
    }

    static func reduce(state: AppState, action: AppAction) -> AppState {
        var appState = state
        switch action {
        case .login(email: let email, password: let password):
            if password == "password" {
                let user = User(email: email, favoritePokemonIDs: [])
                appState.settings.loginUser = user
            }
        }
        return appState
    }
}
