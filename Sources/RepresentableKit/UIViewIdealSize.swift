//
//  UIViewIdealSize.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/27.
//

import UIKit

/// Ideal size for the view. In Auto Layout terms, this is equivalent to the view intrinsic content size.
public struct IdealSize: Hashable {
    /// Ideal width. When nil, the width of view's intrinsic content size will be used.
    public let width: CGFloat?
    
    /// Ideal height. When nil, the height of view's intrinsic content size will be used.
    public let height: CGFloat?
    
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
}

/// Calculation of the ideal size that fits the current size of the view.
public struct UIViewIdealSizeCalculator<Content: UIView> {
    /// Calculate the view ideal size fot a given size.
    public var viewIdealSizeInSize: (Content, CGSize) -> IdealSize
    
    public init(viewIdealSizeInSize: @escaping (Content, CGSize) -> IdealSize) {
        self.viewIdealSizeInSize = viewIdealSizeInSize
    }
}

public extension UIViewIdealSizeCalculator {
    /// Set the ideal size so that ideal width fits inside the proposed frame width. Ideal height is appropriate for the fitted width, but can exceed the proposed height.
    static var `default`: Self {
        .init { content, size in
            let fittingSize = content.systemLayoutSizeFitting(
                size,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            return IdealSize(width: fittingSize.width, height: fittingSize.height)
        }
    }
    
    /// Do not override the ideal size. Use intrinsic content size of the view.
    static var none: Self {
        .init { _, _ in
            IdealSize(width: nil, height: nil)
        }
    }
}
