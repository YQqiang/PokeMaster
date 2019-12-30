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
    
    @GestureState private var translation = CGPoint.zero
    
    init(isPresented: Binding<Bool>, @ViewBuilder content:@escaping () -> Content) {
        self.isPresented = isPresented
        self.makeContent = content
    }
    
    var panelDraggingGesture: some Gesture {
        DragGesture()
            .updating($translation) { (current, state, _) in
                state.y = current.translation.height
            }.onEnded { (state) in
                if state.translation.height > 250 {
                    self.isPresented.wrappedValue = false
                }
            }
    }
    
    var body: some View {
        VStack {
            Spacer()
            makeContent()
        }
        .offset(
            y: (isPresented.wrappedValue ? 0 : UIScreen.main.bounds.height) + max(0, translation.y)
            )
        .animation(.interpolatingSpring(stiffness: 70, damping: 12))
        .edgesIgnoringSafeArea(.bottom)
        .gesture(panelDraggingGesture)
    }
}

extension View {
    func overlaySheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        overlay(
            OverlaySheet(isPresented: isPresented, content: content)
        )
    }
}