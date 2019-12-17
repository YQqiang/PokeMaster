//
//  PokemonList.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/17.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct PokemonList: View {

    @State var expandingIndex: Int?

    var body: some View {
//        List(PokemonViewModel.all) { (pokemon) in
//            PokemonInfoRow(model: pokemon, expanded: false)
//        }

        ScrollView {
            ForEach(PokemonViewModel.all) { (pokemon) in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.expandingIndex == pokemon.id
                )
                .onTapGesture {
                    if self.expandingIndex == pokemon.id {
                        self.expandingIndex = nil
                    } else {
                        self.expandingIndex = pokemon.id
                    }
                }
            }
        }
    }
}
