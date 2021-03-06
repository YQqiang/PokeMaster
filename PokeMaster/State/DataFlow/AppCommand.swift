//
//  AppCommand.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        _ = LoginRequest(
                email: email,
                password: password
            )
            .publisher
            .sink(receiveCompletion: { (completion) in
                if case .failure(let error) = completion {
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                }
            }, receiveValue: { (user) in
                store.dispatch(.accountBehaviorDone(result: .success(user)))
            })
    }
}

struct LoadPokemonsAppCommand: AppCommand {
    func execute(in store: Store) {
        _ = LoadPokemonRequest.all
            .sink(receiveCompletion: { (completion) in
                if case .failure(let error) = completion {
                    store.dispatch(.loadPokemonsDone(result: .failure(error)))
                }
            }, receiveValue: { (value) in
                store.dispatch(.loadPokemonsDone(result: .success(value)))
            })
    }
}

struct RegisterAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        _ = RegisterRequest(email: email, password: password).publisher.sink(receiveCompletion: { (completion) in
            if case .failure(let error) = completion {
                store.dispatch(.accountBehaviorDone(result: .failure(error)))
            }
        }, receiveValue: { (user) in
            store.dispatch(.accountBehaviorDone(result: .success(user)))
        })
    }
}

struct LoadAbilitiesCommand: AppCommand {
    let pokemon: Pokemon
    
    func load(pokemonAbility: Pokemon.AbilityEntry, in store: Store) -> AnyPublisher<AbilityViewModel, AppError> {
        if let value = store.appState.pokemonList.abilities?[pokemonAbility.id.extractedID!] {
            return Just(value)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return LoadAbilityRequest(pokemonAbilityEntry: pokemonAbility).publish
        }
    }
    
    func execute(in store: Store) {
        _ = pokemon.abilities
            .map({ load(pokemonAbility: $0, in: store)})
            .zipAll
            .sink(receiveCompletion: { (completion) in
                if case .failure(let error) = completion {
                    store.dispatch(.loadPokemonsDone(result: .failure(error)))
                }
            }, receiveValue: { (value) in
                store.dispatch(.loadAbilitiesDone(result: .success(value)))
            })
    }
}
