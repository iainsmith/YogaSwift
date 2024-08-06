import Testing
import YogaSwift

@Test func testExample() throws {
  var root = YGNode()
  root.direction = .LTR
  root.flexDirection = .row
  root.width = .init(value: 100, unit: .point)
  root.height = .init(value: 100, unit: .point)

  var child0 = YGNode()
  child0.flexGrow = 1.0
  child0.rightMargin = .init(value: 10, unit: .point)
  var child1 = YGNode()
  child1.flexGrow = 1.0
  root.add(child0)
  root.add(child1)

  root.layout()

  var hasParent = false
  //  child0.parent { parent in
  //    hasParent = true
  //  }
  //
  //  #expect(hasParent == true)
  #expect(root.width.value == 100)
  #expect(root.layoutWidth == 100)

  var count = 0
  root.children { child in
    if count == 0 {
      #expect(child.layoutLeft == 0)
      #expect(child.layoutRight == 10)
      #expect(child.layoutTop == 0)
      #expect(child.layoutBottom == 0)
      #expect(child.layoutWidth == 45)
      #expect(child.layoutHeight == 100)
    }
    if count == 1 {
      #expect(child.layoutLeft == 55)
      #expect(child.layoutRight == 0)
      #expect(child.layoutTop == 0)
      #expect(child.layoutBottom == 0)
      #expect(child.layoutWidth == 45)
      #expect(child.layoutHeight == 100)

    }
    count += 1
  }

  //

  //  #expect(child0.hasNewLayout == true)
  //  child0.hasNewLayout = false
  //  child1.hasNewLayout = false
  //  root.hasNewLayout = false
  //  #expect(child0.hasNewLayout == false)
  //  child0.maxWidth = .init(value: 1000, unit: .point)
  //  #expect(child0.isDirty == true)
  //  #expect(child1.isDirty == false)
  //  root.layout()
  //  #expect(child0.hasNewLayout == true)
}

@Test func testExampleAdding() throws {
  var root = YGNode()
  root.direction = .LTR
  root.flexDirection = .row
  root.width = .init(value: 100, unit: .point)
  root.height = .init(value: 100, unit: .point)

  root.add { child0 in
    child0.flexGrow = 1.0
    child0.rightMargin = .init(value: 10, unit: .point)
  }

  root.add { child1 in
    child1.flexGrow = 1.0
  }

  root.layout()

  var count = 0
  var sizes: [Float] = []
  root.walk { ref in
    count += 1
    ref.height = .auto
    sizes.append(ref.layoutWidth)
  }

  var childrenCount = 0
  root.children { ref in
    ref.width = .auto
    childrenCount += 1
  }

  #expect(root.hasNewLayout == true)
  root.hasNewLayout = false
  #expect(root.hasNewLayout == false)

  #expect(childrenCount == 2)
  #expect(count == 3)
  #expect(root.width.value == 100)
  #expect(root.layoutWidth == 100)
  #expect(sizes == [100, 45, 45])
}

#if canImport(Darwin)
  #if canImport(UIKit)
    import UIKit
  #elseif canImport(AppKit)
    import AppKit
  #endif

//  @Test func testTextNode() throws {
//    var root = YGNode()
//    root.direction = .LTR
//    root.flexDirection = .row
//    root.width = .init(value: 100, unit: .point)
//    root.height = .init(value: 100, unit: .point)
//
//    var child0 = YGNode()
//    child0.flexGrow = 1.0
//    child0.rightMargin = .init(value: 10, unit: .point)
//    var child1 = YGNode()
//    child1.flexGrow = 1.0
//    root.add(child0)
//    root.add(child1)
//
//    let storage = NSTextStorage(AttributedString(stringLiteral: "hello world"))
//    let lm = NSLayoutManager()
//    storage.addLayoutManager(lm)
//    let text = TextNode(yogaNode: YGNode(), layoutManager: lm)
//    root.add(text.yogaNode)
//
//    root.layout()
//
//    #expect(child0.layoutLeft == 0)
//    #expect(child0.layoutRight == 10)
//    #expect(child0.layoutTop == 0)
//    #expect(child0.layoutBottom == 0)
//    #expect(child0.layoutWidth == 11)
//    #expect(child0.layoutHeight == 100)
//
//    #expect(child1.layoutLeft == 21)
//    #expect(child1.layoutRight == 0)
//    #expect(child1.layoutTop == 0)
//    #expect(child1.layoutBottom == 0)
//    #expect(child1.layoutWidth == 12)
//    #expect(child1.layoutHeight == 100)
//
//    #expect(text.yogaNode.layoutLeft == 32)
//    #expect(text.yogaNode.layoutRight == 0)
//    #expect(text.yogaNode.layoutTop == 0)
//    #expect(text.yogaNode.layoutBottom == 0)
//    #expect(text.yogaNode.layoutWidth == 68)
//    #expect(text.yogaNode.layoutHeight == 100)
//  }

#endif
