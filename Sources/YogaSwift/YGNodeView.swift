/// A swift view into a YGNodeConstRef.
public struct YGNodeView: YogaNode, ~Copyable {
  public let __node: YGNodeConstRef

  /// The passed in node will not be released on deinit.
  init(from node: YGNodeConstRef) {
    self.__node = node
  }

  public func walk(_ closure: (inout YGNodeView) -> Void) {
    var rootNode = YGNodeView(from: __node)
    closure(&rootNode)
    let childCount = YGNodeGetChildCount(__node)
    var index = 0
    while index < childCount {
      let child = YGNodeGetChild(__node, index)
      defer { index += 1 }
      guard let child else { continue }
      YGNodeView(from: child).walk(closure)
    }
  }

  public func children(_ closure: (inout YGNodeView) -> Void) {
    let childCount = YGNodeGetChildCount(__node)
    var index = 0
    while index < childCount {
      let child = YGNodeGetChild(__node, index)
      defer { index += 1 }
      guard let child else { continue }
      var node = YGNodeView(from: child)
      closure(&node)
    }
  }
}
