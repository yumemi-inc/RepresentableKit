//
//  UIViewFlexibility.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/27.
//

import UIKit

/// Flexibility of a view is its ability to take a size that is less or more than its ideal size in a dimension.
public struct UIViewFlexibility: OptionSet {
    public let rawValue: Int8
    
    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
    
    /// View width can be compressed to any value in 0...idealWidth.
    public static let minHorizontal = UIViewFlexibility(rawValue: 1 << 0)
    
    /// View width can be stretched to any value in idealWidth...infinity.
    public static let maxHorizontal = UIViewFlexibility(rawValue: 1 << 1)
    
    /// View height can be compressed to any value in 0...idealHeight.
    public static let minVertical = UIViewFlexibility(rawValue: 1 << 2)
    
    /// View height can be stretched to any value in idealHeight...infinity.
    public static let maxVertical = UIViewFlexibility(rawValue: 1 << 3)
    
    /// View width can be compressed and stretched to any value in 0...infinity.
    public static let horizontal: UIViewFlexibility = [.minHorizontal, .maxHorizontal]
    
    /// View height can be compressed and stretched to any value in 0...infinity.
    public static let vertical: UIViewFlexibility = [.minVertical, .maxVertical]
    
    /// View width and height can be compressed and stretched to any value in 0...infinity.
    public static let all: UIViewFlexibility = [.horizontal, .vertical]
    
    /// View width and height must maintain their ideal size and can not be stretched or compressed.
    public static let none: UIViewFlexibility = []
    
    /// SwiftUI picks up UIView flexibility from its compression resistance and content hugging priorities.
    /// A value of .defaultHigh (750) and above signifies that the view is not flexible for this dimension and should maintain its ideal size.
    public func priority(_ value: UIViewFlexibility) -> UILayoutPriority {
        contains(value) ? .defaultLow : .defaultHigh
    }
}

extension UIView {
    /// Set compression resistance and content hugging priorities so that SwiftUI can pick up the flexibility of this view.
    func apply(flexibility: UIViewFlexibility) {
        setContentCompressionResistancePriority(flexibility.priority(.minHorizontal), for: .horizontal)
        setContentCompressionResistancePriority(flexibility.priority(.minVertical), for: .vertical)
        setContentHuggingPriority(flexibility.priority(.maxHorizontal), for: .horizontal)
        setContentHuggingPriority(flexibility.priority(.maxVertical), for: .vertical)
    }
}
