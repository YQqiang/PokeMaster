//
//  PokemonList.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/17.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct PokemonList: View {

    @EnvironmentObject var store: Store

    var body: some View {
//        List(PokemonViewModel.all) { (pokemon) in
//            PokemonInfoRow(model: pokemon, expanded: false)
//        }

        ScrollView {
            TextField("搜索", text: $store.appState.pokemonList.searchText)
                .frame(height: 40)
                .padding(.horizontal, 25)
            ForEach(store.appState.pokemonList.allPokemonsById) { (pokemon) in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.store.appState.pokemonList.selectionState.isExpanding(pokemon.id)
                )
                .onTapGesture {
                    self.store.dispatch(.toggleListSelection(index: pokemon.id))
                    self.store.dispatch(.loadAbilities(pokemon: pokemon.pokemon))
                }
            }
        }
//        .overlay(
//            VStack {
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }
//        )
//        .edgesIgnoringSafeArea(.bottom)
    }
}
