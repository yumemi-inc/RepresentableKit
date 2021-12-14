//
//  UIViewAdapter.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI

/// Adapt UIKit views to be used in SwiftUI.
public struct UIViewAdapter<Content, Representable: UIViewRepresentable>: View where Representable.UIViewType == Content {
    typealias Holder = UIViewHolder<Content>
    
    struct SizeKey: PreferenceKey {
        public static var defaultValue: CGSize { .zero }
        
        public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
    
    @State private var holder: Holder
    
    let representableFactory: () -> Representable
    
    /// - Parameters:
    ///   - flexibility: View dimensions that can be compressed/stretched.
    ///   - idealSizeCalculator: Calculation of the ideal size that fits the current size of the view.
    ///   - view: `UIView` factory.
    ///   - representable: Factory method that creates `UIViewRepresentable` appropriate for the view.
    public init(
        flexibility: UIViewFlexibility = .all,
        idealSizeCalculator: UIViewIdealSizeCalculator<Content> = .default,
        representable: @escaping () -> Representable
    ) {
        self._holder = .init(
            initialValue: UIViewHolder(flexibility: flexibility, idealSizeCalculator: idealSizeCalculator)
        )
        self.representableFactory = representable
    }
    
    public var body: some View {
        RepresentableWrapper(wrap: representableFactory(), holder: $holder)
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: SizeKey.self, value: proxy.size)
                    .onPreferenceChange(SizeKey.self) { holder.updateSize(proxySize: $0) }
            })
            .frame(
                idealWidth: holder.idealSize.width,
                idealHeight: holder.idealSize.height
            )
    }
}

public extension UIViewAdapter where Representable == BasicUIViewRepresentable<Content> {
    init(
        flexibility: UIViewFlexibility = .all,
        idealSizeCalculator: UIViewIdealSizeCalculator<Content> = .default,
        makeUIView: @escaping () -> Content
    ) {
        self.init(
            flexibility: flexibility,
            idealSizeCalculator: idealSizeCalculator,
            representable: { BasicUIViewRepresentable(makeUIView: makeUIView) }
        )
    }
}

// MARK: -

/// Class responsible for setting the view flexibility and updating the ideal size.
struct UIViewHolder<Content: UIView> {
    /// Storage for the view. To avoid holding on to the instance after SwiftUI has already discarded the view, this storage is weak.
    final class ViewStorage {
        weak var view: Content?
    }
    
    private let storage = ViewStorage()
    
    let flexibility: UIViewFlexibility
    
    let idealSizeCalculator: UIViewIdealSizeCalculator<Content>
    
    var idealSize = IdealSize(width: nil, height: nil)
        
    mutating func updateView(_ uiView: Content) {
        storage.view = uiView
        uiView.apply(flexibility: flexibility)
        updateSize(proxySize: uiView.frame.size)
    }
    
    mutating func updateSize(proxySize: CGSize) {
        guard let uiView = storage.view else { return }
        idealSize = idealSizeCalculator.viewIdealSizeInSize(uiView, proxySize)
    }
    
    #if DEBUG
    private struct ProposedSize {
        let width: CGFloat?
        let height: CGFloat?
    }
    
    // ⚠️: This function uses private SwiftUI API. Make sure to use it only for debug purposes and never in the actual release build of the app.
    // Override size calculation for UIViewRepresentable to calculate the correct ideal size for the view on the first go.
    // This is a workaround for Xcode Previews limitation for .sizeThatFits preview layout of views that are set to .fixedSize().
    // Since we are using a GeometryReader to update ideal size, it will take several layout passes for the view become the correct size.
    // Xcode Previews, however, will take the size reported in the first layout pass, even though they show the actual view laid out correctly.
    func overrideSizeThatFits(_ size: inout CGSize, in proposedSize: SwiftUI._ProposedSize, uiView: Content) {
        let proposedSize = unsafeBitCast(proposedSize, to: ProposedSize.self)
        
        let targetSize = CGSize(
            width: proposedSize.width ?? UIView.layoutFittingCompressedSize.width,
            height: proposedSize.height ?? UIView.layoutFittingCompressedSize.height
        )
        
        let idealSize = idealSizeCalculator.viewIdealSizeInSize(uiView, targetSize)
        
        if proposedSize.width == nil, let idealWidth = idealSize.width {
            size.width = idealWidth
        }
        
        if proposedSize.height == nil, let idealHeight = idealSize.height {
            size.height = idealHeight
        }
    }
    #endif
}

// MARK: -

/// A basic representable to be used in cases where the view does not need any customization or interactivity after instantiation.
public struct BasicUIViewRepresentable<Content: UIView>: UIViewRepresentable {
    public typealias UIViewType = Content
    
    public let makeUIView: () -> Content
    
    public func makeUIView(context: Context) -> UIViewType {
        makeUIView()
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) { }
}

/// UIViewRepresentable wrapper that passes its view to the outside view holder
public struct RepresentableWrapper<Wrapped: UIViewRepresentable>: UIViewRepresentable {
    public typealias UIViewType = Wrapped.UIViewType
    
    public typealias Coordinator = Wrapped.Coordinator
    
    let wrap: Wrapped
    
    @Binding var holder: UIViewHolder<UIViewType>
    
    public func makeCoordinator() -> Wrapped.Coordinator {
        wrap.makeCoordinator()
    }
    
    public func makeUIView(context: Context) -> Wrapped.UIViewType {
        let uiView = wrap.makeUIView(context: unsafeBitCast(context, to: Wrapped.Context.self))
        holder.updateView(uiView)
        return uiView
    }
    
    public func updateUIView(_ uiView: Wrapped.UIViewType, context: Context) {
        wrap.updateUIView(uiView, context: unsafeBitCast(context, to: Wrapped.Context.self))
    }
    
    public static func dismantleUIView(_ uiView: Wrapped.UIViewType, coordinator: Wrapped.Coordinator) {
        Wrapped.dismantleUIView(uiView, coordinator: coordinator)
    }
    
    // ⚠️: This is private SwiftUI API. Make sure to use it only for debug purposes and never in the actual release build of the app.
    #if DEBUG
    public func _overrideSizeThatFits(_ size: inout CGSize, in proposedSize: SwiftUI._ProposedSize, uiView: UIViewType) {
        holder.overrideSizeThatFits(&size, in: proposedSize, uiView: uiView)
    }
    #endif
}
