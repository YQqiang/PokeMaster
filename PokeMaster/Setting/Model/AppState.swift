//
//  AppState.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

struct AppState {
    var settings = Settings()
    var pokemonList = PokemonList()
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, color, name, favorite
        }

        @UserDefaultsStorage(key: "showEnglishName", defaultValue: false)
        var showEnglishName: Bool

        var sorting: Sorting = .id

        @UserDefaultsStorage(key: "showFavoriteOnly", defaultValue: false)
        var showFavoriteOnly: Bool

        enum AccountBehavior: CaseIterable {
            case register, login
        }

        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?

        var loginRequesting = false

        var loginError: AppError?

        var isEmailValid: Bool = false

        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""

            var isEmailVaid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { (email) -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email).publisher.eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                return Publishers.CombineLatest3(remoteVerify, emailLocalValid, canSkipRemoteVerify)
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }
        }

        var checker = AccountChecker()
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}

extension AppState {
    struct PokemonList {
        var pokemons: [Int: PokemonViewModel]?
        var loadingPokemons = false
        
        var allPokemonsById: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
    }
}
