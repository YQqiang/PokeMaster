//
//  User.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation

struct User: Codable {

    var email: String

    var favoritePokemonIDs: Set<Int>

    func isFavoritePokemonID(_ id: Int) -> Bool {
        favoritePokemonIDs.contains(id)
    }
}
