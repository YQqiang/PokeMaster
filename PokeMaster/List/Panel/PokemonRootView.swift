//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/18.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {

    var body: some View {
        NavigationView {
            PokemonList()
                .navigationBarTitle("宝可梦列表")
        }
    }
}
