//
//  UISlider+Previews.swift
//  
//
//  Created by Mikhail Apurin on 2021/10/26.
//

import SwiftUI

// UISlider is notable as a system component that has a specified
// intrinsic content height, but not width

struct UISlider_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewAdapter {
                UISlider()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .frame(width: 150)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Size that fits: (W 150 H ideal)")
            
            UISliderFiddler()
                .previewDisplayName("Synchronized UISlider + SwiftUI Slider")
        }
    }
}

struct UISliderFiddler: View {
    let min: CGFloat = -1
    
    let max: CGFloat = 1
    
    @State var value: CGFloat = 0
    
    var body: some View {
        Fiddler {
            ForEach(0...10, id: \.self) { _ in
                HStack(spacing: 16) {
                    UIViewAdapter {
                        // Using a custom UIViewRepresentable that is defined below
                        UISliderView(min: min, max: max, value: $value)
                    }
                    
                    UIViewAdapter {
                        // Using a custom UIViewRepresentable that is defined below
                        UISliderView(min: min, max: max, value: $value)
                    }
                }
            }
            .accentColor(.red)
            .padding()
        } controls: {
            Slider(value: $value, in: min...max)
                .padding(.horizontal)
        }
    }
}

/// A custom UISlider representable to enable interacting with the view.
struct UISliderView: UIViewRepresentable {
    let min: CGFloat
    
    let max: CGFloat
    
    @Binding var value: CGFloat
    
    final class Coordinator {
        var control: UISliderView
        
        init(_ control: UISliderView) {
            self.control = control
        }
        
        @objc func updateValue(sender: UISlider) {
            control.value = CGFloat(sender.value)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISlider {
        let uiView = UISlider()
        uiView.addTarget(context.coordinator, action: #selector(Coordinator.updateValue(sender:)), for: .valueChanged)
        return uiView
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.minimumValue = Float(min)
        uiView.maximumValue = Float(max)
        uiView.value = Float(value)
    }
}
