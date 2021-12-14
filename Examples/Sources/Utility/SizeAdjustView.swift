//
//  SizeAdjustView.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/27.
//

import SwiftUI

struct SizeAdjustView<Canvas: View, Controls: View>: View {
    let canvas: Canvas
    
    let controls: Controls
    
    init(@ViewBuilder canvas: () -> Canvas, @ViewBuilder controls: () -> Controls) {
        self.canvas = canvas()
        self.controls = controls()
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                canvas
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Divider()
            
            controls
                .padding(.vertical)
        }
    }
}
