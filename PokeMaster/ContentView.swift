//
//  ContentView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/17.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            PokemonInfoRow(model: PokemonViewModel.sample(id: 1), expanded: false)
            PokemonInfoRow(model: PokemonViewModel.sample(id: 21), expanded: true)
            PokemonInfoRow(model: PokemonViewModel.sample(id: 25), expanded: false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
