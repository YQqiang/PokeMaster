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
    var mainTab = MainTab()
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
        var isEmailPasswordValid: Bool = false
        
        var clearCacheSuccess: Bool = false

        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var emailPwdPublisher: AnyPublisher<Bool, Never> {
                let emailVerify = isEmailVaid
                let passwordVerify = isPasswordValid
                return Publishers.CombineLatest(emailVerify, passwordVerify)
                    .map { $0 && $1}
                    .eraseToAnyPublisher()
            }
            
            var isPasswordValid: AnyPublisher<Bool, Never> {
                let passwordVerify = $password.map { $0.count > 0 }
                let verifyPasswordVerify = $verifyPassword.map { $0.count > 0 }
                let samePasswordVerify = $password.combineLatest($verifyPassword)
                    .map { $0 == $1 }
                    .eraseToAnyPublisher()
                let canSkipSameVerify = $accountBehavior.map { $0 == .login }
                return Publishers.CombineLatest4(passwordVerify, verifyPasswordVerify, samePasswordVerify, canSkipSameVerify)
                    .map { $3 ? $0 : $0 && $1 && $2 }
                    .eraseToAnyPublisher()
            }

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
        
        struct SelectionState {
            var expandingIndex: Int?
            var panelIndex: Int?
            var panelPresented = false
            
            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }
        
        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?
        var loadingPokemons = false
        
        var error: AppError?
        var searchText: String = ""
        var selectionState = SelectionState()
        
        var allPokemonsById: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
        
        /// 按 ID 缓存所有的 AbilityViewModel
        @FileStorage(directory: .cachesDirectory, fileName: "abilities.json")
        var abilities: [Int: AbilityViewModel]?
        
        /// 返回 某个 Pokemon 的所有技能的 AbilityViewModel
        /// - Parameter pokemon: pokemon
        func abilityViewModels(_ pokemon: Pokemon) -> [AbilityViewModel]? {
            guard let abilities = abilities else {
                return nil
            }
            return pokemon.abilities.compactMap { abilities[$0.ability.url.extractedID!]
            }
        }
        
        var isSFViewActive = false
    }
}

extension AppState {
    struct MainTab {
        enum Index: Hashable {
            case list, settings
        }
        var selection: Index = .list
    }
}
