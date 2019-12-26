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

    let disposeBag = DisposeBag()

    init() {
        setupObservers()
    }

    func setupObservers() {
        appState.settings.checker.isEmailVaid.sink { (isValid) in
            self.dispatch(.emailValid(valid: isValid))
        }.add(to: disposeBag)
        
        appState.settings.checker.emailPwdPublisher.sink { (isValid) in
            self.dispatch(.emailPasswordValid(valid: isValid))
        }.add(to: disposeBag)
    }

    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]:\(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0

        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]:\(command)")
            #endif
            command.execute(in: self)
        }
    }

    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?

        switch action {
        case .login(email: let email, password: let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
        case .logout:
            appState.settings.loginUser = nil
        case .emailValid(valid: let valid):
            appState.settings.isEmailValid = valid
            
        case .emailPasswordValid(valid: let valid):
            appState.settings.isEmailPasswordValid = valid
            
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            appState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonsAppCommand()
        case .loadPokemonsDone(result: let result):
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons = Dictionary.init(uniqueKeysWithValues: models.map({ ($0.id, $0)} ))
            case .failure(let error):
                print(error)
            }
        }
        return (appState, appCommand)
    }
}
