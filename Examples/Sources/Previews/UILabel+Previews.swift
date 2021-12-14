//
//  UILabel+Previews.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI
import RepresentableKit

// UILabel is notable as a system component that has a specified intrinsic
// content size which reflects its text content. By default, width/height
// is calculated without any bounds, but you can set `preferredMaxLayoutWidth`
// to non-zero value as the upper bound for width.

let lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dignissim congue justo ac dignissim. Integer eget semper mi. In non vestibulum risus."

struct UILabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewAdaptor {
                makeMultilineLabel(text: "Some text")
            }
            .previewDisplayName("Size that fits: (W ideal H ideal)")
            
            UIViewAdaptor {
                makeMultilineLabel(text: lipsum)
            }
            .frame(width: 390)
            .previewDisplayName("Size that fits: (W 390 H ideal)")

            UIViewAdaptor {
                makeMultilineLabel(text: lipsum)
            }
            .frame(idealWidth: 390, idealHeight: 44)
            .previewDisplayName("Size that fits: (W 390 H 44)")
        }
        .border(Color.red)
        .padding()
        .fixedSize()
        .previewLayout(.sizeThatFits)
        
        Group {
            UILabelSizeAdjustView(text: lipsum)
                .previewDisplayName("Interactively fit view in specified width")
        }
    }
    
    static func makeMultilineLabel(text: String) -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = text
        return view
    }
}

struct UILabelSizeAdjustView: View {
    let text: String
    
    @State var width: Double = 200
    
    @State var currentSize: CGSize = .zero
    
    var body: some View {
        SizeAdjustView {
            UIViewAdaptor {
                let view = UILabel()
                view.numberOfLines = 0
                view.text = text
                return view
            }
            .frame(width: width)
            .fixedSize()
            .border(Color.orange)
        } controls: {
            Slider(value: $width, in: 0...currentSize.width)
                .padding(.horizontal)
        }
        .inspectSize($currentSize)
    }
}
