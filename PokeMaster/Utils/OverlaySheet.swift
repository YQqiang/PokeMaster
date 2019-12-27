//
//  OverlaySheet.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/27.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import SwiftUI

struct PokemonInfoPanelOverlay: View {
    let model: PokemonViewModel
    var body: some View {
        VStack {
            Spacer()
            PokemonInfoPanel(model: model)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
