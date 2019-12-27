//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/18.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            if store.appState.pokemonList.error != nil {
                RetryView()
                    .onTapGesture {
                        self.store.dispatch(.loadPokemons)
                    }
            } else if store.appState.pokemonList.pokemons == nil {
                Text("Loading...").onAppear() {
                    self.store.dispatch(.loadPokemons)
                }
            } else {
                PokemonList()
                    .navigationBarTitle("宝可梦列表")
            }
        }
    }
}
