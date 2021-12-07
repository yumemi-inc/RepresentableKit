//
//  UILabel+Previews.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI
import PreviewKit

// UILabel is notable as a system component that has a specified intrinsic
// content size which reflects its text content. By default, width/height
// is calculated without any bounds, but you can set `preferredMaxLayoutWidth`
// to non-zero value as the upper bound for width.

struct UILabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewAdapter {
                makeMultilineLabel(text: "テキスト")
            }
            .previewDisplayName("Size that fits: (W ideal H ideal)")
            
            UIViewAdapter {
                makeMultilineLabel(text: "長さ十分で複数行以上にいけるテストになると思ったけど、長さが足りなくてつまらないことを入れた。")
            }
            .frame(width: 390)
            .previewDisplayName("Size that fits: (W 390 H ideal)")

            UIViewAdapter {
                makeMultilineLabel(text: "長さ十分で複数行以上にいけるテストになると思ったけど、長さが足りなくてつまらないことを入れた。")
            }
            .frame(idealWidth: 390, idealHeight: 44)
            .previewDisplayName("Size that fits: (W 390 H 44)")
        }
        .border(Color.red)
        .padding()
        .fixedSize()
        .previewLayout(.sizeThatFits)
        
        Group {
            UILabelFiddler(
                text: "長さ十分で複数行以上にいけるテストになると思ったけど、長さが足りなくてつまらないことを入れた。"
            )
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

struct UILabelFiddler: View {
    let text: String
    
    @State var width: Double = 200
    
    @State var currentSize: CGSize = .zero
    
    var body: some View {
        Fiddler {
            UIViewAdapter {
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
