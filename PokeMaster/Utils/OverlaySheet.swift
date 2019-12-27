//
//  OverlaySheet.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/27.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import SwiftUI

struct OverlaySheet<Content: View>: View {
    private let isPresented: Binding<Bool>
    private let makeContent: () -> Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content:@escaping () -> Content) {
        self.isPresented = isPresented
        self.makeContent = content
    }
    
    var body: some View {
        VStack {
            Spacer()
            makeContent()
        }
        .offset(y: isPresented.wrappedValue ? 0 : UIScreen.main.bounds.height)
        .animation(.interpolatingSpring(stiffness: 70, damping: 12))
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension View {
    func overlaySheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        overlay(
            OverlaySheet(isPresented: isPresented, content: content)
        )
    }
}
