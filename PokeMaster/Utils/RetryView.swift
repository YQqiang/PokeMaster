//
//  RetryView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/27.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import SwiftUI

struct RetryView: View {
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(Color.gray)
            Text("Retry")
                .foregroundColor(Color.gray)
        }
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray, style:
                    StrokeStyle(lineWidth: 1)
                )
            .padding(-8)
        )
    }
}
