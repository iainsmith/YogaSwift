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
let height = child0.layoutHeight
```

## Swift 6 only for now

### Noncopyable Types

`YGNode` and `YGConfiguration` are ~Copyable (Noncopyable) types, so that they can free the underlying yoga nodes on deinit.

### Generic Implementation

The majority of the yoga node api is implemented through the `YogaNode` protocol. This makes it easy to create custom wrappers such as `TextNode`, `VStack` that can use the appropriate node api, and provide their own custom logic / additional api.

### Safety

- Yoga internally calls assertFatal in a few places. Ideally we'd wrap these in throwing swift methods, so that the incorrect usage of the yoga api will never crash.

## Status

Target Platforms: All swift supported platforms.s
Experimental. API design may change in 0.0.X releases.

## Experimental TextKit support on Apple Platforms

`TextNode` is an experimental apple `YogaNode` that wraps an NSLayoutManager. This is currently a POC, that needs refinement.

## TODO:

- update closure apis to use `borrowing` rather than `inout`
- update macros to have nonmutating setters.
- generate swift tests
- Review margin/padding/children API
- TextNode support
- Remove macro duplication
- Setup linux CI / upstream attribute changes
