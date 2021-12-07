//
//  SizeGetter.swift
//  
//
//  Created by Mikhail Apurin on 2021/12/03.
//

import SwiftUI

public struct SizeKey: PreferenceKey {
    public typealias Value = CGSize
    
    public static var defaultValue: Value { .zero }
    
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
