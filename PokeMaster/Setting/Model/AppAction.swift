//
//  AppAction.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import SwiftUI

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)

    case logout
    case emailValid(valid: Bool)
    
    case emailPasswordValid(valid: Bool)
    case register(email: String, password: String)
    
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
    
    case clearCache
    
    case toggleListSelection(index: Int)
    
}
