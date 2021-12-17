# RepresentableKit

Apple provides us two ways to use UIKit views in SwiftUI:

1. [`UIViewRepresentable`](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)
1. [`UIViewControllerRepresentable`](https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable)

The way those Views interact with the layout system are not really well-documented and can be a pain to implement correctly.

RepresentableKit seeks to minimize the hurdle of using UIKit views, especially for previews where it is not reasonable to spend time fixing layout issues manually. We provide a wrapper over `UIViewRepresentable` that abstracts the internal SwiftUI layout process and has the most useful (opinionated) default layout handling.

A minimal usage example would be previewing a simple `UILabel` with multiple lines of text. 

```swift
import SwiftUI
import RepresentableKit

struct UILabel_Previews: PreviewProvider {
    static var previews: some View {
        UIViewAdaptor {
            let view = UILabel()
            view.numberOfLines = 0
            view.text = "To love the journey is to accept no such end. I have found, through painful experience, that the most important step a person can take is always the next one."
            return view
        }
        .padding()
    }
}
```

Note that had we chosen to write this naively with `UIViewRepresentable` without further customizing layout, it would render as a single line of text.

For further examples, see the provided [`Examples`](Examples/) project. 

# Installation

Use Swift Package Manager to install RepresentableKit.

- Use Xcode and add this repository as a dependency.
- Alternatively, add this repository as a `dependency` to your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/yumemi-inc/RepresentableKit.git", .upToNextMajor(from: "0.1.0"))
]
```


# UIViewRepresentable

Let's look at how `UIViewRepresentable` chooses an appropriate size for the contained UIView.

First thing we need to know is the general SwiftUI layout procedure (from [WWDC19: Building Custom Views with SwiftUI](https://developer.apple.com/videos/play/wwdc2019/237/?time=283)).

1. Parent proposes a size for child
1. Child chooses its own size
1. Parent places child in parent's coordinate space

The second bit of knowledge is that SwiftUI views have 3 size values for each dimension: min, ideal, max. Min and max are used to clamp the proposed size, while ideal size is used when the proposed size is nil (achived by [.fixedSize()](https://developer.apple.com/documentation/swiftui/view/fixedsize()) view modifier).

`UIViewRepresentable` uses Auto Layout intrinsic content size and layout priorities to map the contained UIView size. 

| [Intrinsic Content Size](https://developer.apple.com/documentation/uikit/uiview/1622600-intrinsiccontentsize) | [Compression Resistance](https://developer.apple.com/documentation/uikit/uiview/1622465-contentcompressionresistanceprio/) | [Hugging](https://developer.apple.com/documentation/uikit/uiview/1622556-contenthuggingpriority/) | Result size |
|---|---|---|---|
| (-1) | - | - | `0 … 0 … ∞` |
| x | < 750 | < 750 | `0 … x … ∞` |
| x | < 750 | >= 750 | `0 … x … x` |
| x | >= 750 | < 750 | `x … x … ∞` |
| x | >= 750 | >= 750 | `x … x … x` |

- The result size is shown as `min … ideal … max`
- `-1` = [`UIView.noIntrinsicMetric`](https://developer.apple.com/documentation/uikit/uiview/1622486-nointrinsicmetric/)
- `750` = [`UILayoutPriority.defaultHigh`](https://developer.apple.com/documentation/uikit/uilayoutpriority/1622249-defaulthigh)

`UIViewRepresentable` will also listen to [invalidateIntrinsicContentSize()](https://developer.apple.com/documentation/uikit/uiview/1622457-invalidateintrinsiccontentsize/) to update its size.

Using UILabel as an example, with default priorities and intrinsic size it will map to size `x … x … ∞`, e.g. it will not become smaller than the intrinsic size, but can grow to any size; with `fixedSize()` applied it will become its intrinsic content size.

Most custom UIViews, however, don't have an intrinsic size, so they will map to `0 … 0 … ∞`, e.g. growing and shrinking to any value SwiftUI proposes and vanishing (taking size 0) with `fixedSize()` applied.

RepresentableKit abstracts over those concepts in two ways:

1. [UIViewFlexibility](Sources/RepresentableKit/UIViewFlexibility.swift) to control min/max sizes via the layout priorities.
1. [UIViewIdealSizeCalculator](Sources/RepresentableKit/UIViewIdealSize.swift) to control the ideal size.

You can specify a custom sizing behavior by modifying [`UIViewAdaptor.init`](Sources/RepresentableKit/UIViewAdaptor.swift) attributes.

# UIViewControllerRepresentable

For now, RepresentableKit does not provide any compatibility with `UIViewControllerRepresentable`.
