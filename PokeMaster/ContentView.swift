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
        let store = Store()
        store.appState.settings.sorting = .color
        return MainTab().environmentObject(store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
