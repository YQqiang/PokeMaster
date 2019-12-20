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
    @State var searchText: String = ""

    var body: some View {
//        List(PokemonViewModel.all) { (pokemon) in
//            PokemonInfoRow(model: pokemon, expanded: false)
//        }

        ScrollView {
            TextField("搜索", text: $searchText)
                .frame(height: 40)
                .padding(.horizontal, 25)
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
//        .overlay(
//            VStack {
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }
//        )
//        .edgesIgnoringSafeArea(.bottom)
    }
}
