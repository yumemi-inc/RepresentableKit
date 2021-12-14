//
//  SizeGetter.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI
import RepresentableKit

struct SizeGetter: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: SizeKey.self, value: proxy.size)
                    .onPreferenceChange(SizeKey.self) { size = $0 }
            })
    }
}

extension View {
    func inspectSize(_ size: Binding<CGSize>) -> some View {
        self
            .modifier(SizeGetter(size: size))
    }
}
