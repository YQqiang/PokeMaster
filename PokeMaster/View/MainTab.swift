//
//  MainTab.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/18.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var store: Store
    
    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }

    private var selectedPanelIndex: Int? {
        pokemonList.selectionState.panelIndex
    }
    
    var body: some View {
        TabView {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .edgesIgnoringSafeArea(.top)
        .overlaySheet(isPresented: pokemonListBinding.selectionState.panelPresented) {
            if self.selectedPanelIndex != nil
                && self.pokemonList.pokemons != nil {
                PokemonInfoPanelOverlay(model: self.pokemonList.pokemons![self.selectedPanelIndex!]!)
            }
        }
    }
    
    var panel: some View {
        Group {
            if store.appState.pokemonList.selectionState.panelPresented {
                if selectedPanelIndex != nil
                    && pokemonList.pokemons != nil {
                    PokemonInfoPanelOverlay(model: pokemonList.pokemons![selectedPanelIndex!]!)
                } else {
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
    }
}
