//
//  SizeGetter.swift
//  
//
//  Created by Mikhail Apurin on 2021/12/03.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    typealias Value = CGSize
    
    static var defaultValue: Value { .zero }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
