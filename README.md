# Yoga Swift

A swift package wrapper for the [yoga layout](https://github.com/facebook/yoga) 3.0.0+ flexbox engine.

## Example usage

Translated examples from [Building a yoga tree](https://www.yogalayout.dev/docs/getting-started/laying-out-a-tree#building-a-yoga-tree)

```swift
import YogaSwift

var root = YGNode()
root.direction = .LTR
root.width = YGValue(value: 100, unit: .point)
root.height = YGValue(value: 100, unit: .point)

var child0 = YGNode()
child0.flexGrow = 1.0
child0.rightMargin = YGValue(value: 10, unit: .point)
root.add(child0)

var child1 = YGNode()
child1.flexGrow = 1.0
root.add(child1)

root.layout()

let left = child0.layoutMargin(for: .left)
let height = child0.layoutHeight;
```

## Swift main branch required

- This is an experimental branch looking at HypoArray
- Download a trunk swift toolchain from August 2024 or later https://www.swift.org/download/
- run `export TOOLCHAINS=$(plutil -extract CFBundleIdentifier raw \
 /Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist)`
- run `swift test`



### Noncopyable Types

`YGNode` and `YGConfiguration` are ~Copyable (Noncopyable) types, so that they can free the underlying yoga nodes on deinit.

## Status

Target Platforms: All swift supported platforms.
Experimental. API design may change in 0.0.X releases.

## Experimental TextKit support on Apple Platforms

`TextNode` is an experimental apple `YogaNode` that wraps an NSLayoutManager. This is currently a POC, that needs refinement.

## TODO:

- Review margin/padding/children API
- TextNode support
- Remove macro duplication
- Setup CI
