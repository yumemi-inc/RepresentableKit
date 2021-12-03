//
//  CustomUIView+Previews.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI
import UIViewPreview

// A simple custom UIView that is laid out with Auto Layout and does not customize
// its intrinsic content size (which defaults to UIView.noIntrinsicMetric).

struct CustomUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewAdapter {
                CustomUIView()
            }
            .frame(width: 160)
            .fixedSize()
            .border(Color.orange, width: 1)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Size that fits: (W 160 H ideal)")
            
            ScrollView {
                ForEach(0...10, id: \.self) { _ in
                    VStack {
                        HStack {
                            UIViewAdapter {
                                CustomUIView()
                            }
                            .border(.orange, width: 1)
                            
                            UIViewAdapter {
                                CustomUIView()
                            }
                            .border(.orange, width: 1)
                        }
                        
                        VStack {
                            UIViewAdapter {
                                CustomUIView()
                            }
                            .border(.orange, width: 1)
                            
                            UIViewAdapter {
                                CustomUIView()
                            }
                            .border(.orange, width: 1)
                        }
                    }
                }
                .padding()
            }
        }
        .previewDisplayName("Fit view in mixed stacks")
    }
}

/// A simple custom UIView with an image, a main label and a secondary label.
final class CustomUIView: UIView {
    private(set) lazy var imageView = makeImageView(
        systemName: "photo.on.rectangle.angled"
    )
    
    private(set) lazy var mainLabel = makeLabel(
        text: "Lorem ipsum dolor sit amet",
        font: .preferredFont(forTextStyle: .body),
        color: .label
    )
    
    private(set) lazy var detailLabel = makeLabel(
        text: "Consectetur adipiscing elit. Integer sed dui at risus porta venenatis in sed ante.",
        font: .preferredFont(forTextStyle: .caption2),
        color: .secondaryLabel
    )
    
    private func makeImageView(systemName: String) -> UIImageView {
        let view = UIImageView(image: UIImage(systemName: systemName))
        view.preferredSymbolConfiguration = .init(textStyle: .title1)
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.systemGray
        return view
    }
    
    private func makeLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = text
        view.font = font
        view.textColor = color
        return view
    }
    
    init() {
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        [imageView, mainLabel, detailLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            mainLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            mainLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            mainLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            detailLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            detailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            detailLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}
