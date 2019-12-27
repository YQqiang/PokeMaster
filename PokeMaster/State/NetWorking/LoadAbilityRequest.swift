//
//  LoadAbilityRequest.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/27.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

struct LoadAbilityRequest {
    
    let pokemonAbilityEntry: Pokemon.AbilityEntry
    
    var publish: AnyPublisher<AbilityViewModel, AppError> {
        URLSession.shared
            .dataTaskPublisher(for: pokemonAbilityEntry.ability.url)
            .map({ $0.data })
            .decode(type: Ability.self, decoder: appDecoder)
            .map { AbilityViewModel(ability: $0) }
            .mapError { AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
