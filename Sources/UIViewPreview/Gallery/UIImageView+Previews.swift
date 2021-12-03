//
//  UIImageView+Previews.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI

// UIImageView is notable as a system component that has a specified
// intrinsic content size that is equal to its UIImage dimensions.

struct UIImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewAdapter {
                makeView()
            }
            .aspectRatio(contentMode: .fit)
            .padding()
            .frame(width: 100)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Size that fits: (W 100 H ideal) / original aspect ratio")
            
            ScrollView {
                ForEach(0...10, id: \.self) { _ in
                    HStack {
                        UIViewAdapter {
                            makeView()
                        }
                        .aspectRatio(nil, contentMode: .fit)
                        
                        UIViewAdapter {
                            makeView()
                        }
                        .aspectRatio(nil, contentMode: .fit)
                    }
                }
                .padding()
            }
            .previewDisplayName("Fit view in HStacks with original aspect ratio")
        }
    }
    
    static func makeView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart")
        return view
    }
}
