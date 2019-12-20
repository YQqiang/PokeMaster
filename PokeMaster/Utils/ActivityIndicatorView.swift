//
//  ActivityIndicatorView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/20.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicatorView: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style

    typealias UIViewType = UIActivityIndicatorView

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> ActivityIndicatorView.UIViewType {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        return indicator
    }

    func updateUIView(_ uiView: ActivityIndicatorView.UIViewType, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        uiView.style = style
    }

}

