# ObservedOptionalObject

[![Swift](https://github.com/fourplusone/observed-optional-object/actions/workflows/swift.yml/badge.svg)](https://github.com/fourplusone/observed-optional-object/actions/workflows/swift.yml)

## Rationale

`SwiftUI`s `@ObservedObject` requires that the observed object actually exists. In some cases
it's convenient to observe an object which might be nil. In this case, `@ObservedOptionalObject` can be used.

```swift
struct SomeView: View {
    // Instead of
    @ObservedObject var anObject: Model? // Won't work
    
    // use
    @ObservedOptionalObject var anObject: Model?
    
    var body: some View {
        HStack {
            Text("Name")
            if let name = anObject?.name {
                Text(name)
            }
        }
    }
}
```

Please note, that  `@ObservedOptionalObject` is only useful if your contains content that should
be displayed, even when the object is `nil`. Otherwise the view should be contained within an `if let`  statement:
`if let obj = obj { SomeView(anObject: obj) }`

## Installation

This package is available via SwiftPM

```swift
dependencies: [
    .package(url: "https://github.com/fourplusone/observed-optional-object.git", 
        .upToNextMinor(from: "0.1.0")
    )
]
```

## License

This project is licensed under the MIT License.
