import yoga

/// A ``YogaNode`` that owns the ``YogaNode/node`` and will free it on deinit.
public struct YGNode: YogaNode, ~Copyable {
  public let __node: YGNodeRef
  public var children: Hypoarray<YGNode> = .init()

  public init(configuration: borrowing YogaConfiguration) {
    self.__node = YGNodeNewWithConfig(configuration.config)
  }

  public init() {
    self.__node = YGNodeNew()
  }

  public init(from node: consuming YGNodeRef) {
    self.__node = node
  }

  mutating public func add(_ element: consuming YGNode) {
    let count = YGNodeGetChildCount(__node)
    YGNodeInsertChild(__node, element.__node, count)
    children.append(element)
  }

  /// Add a child at the last index that will be owned by this ``Node``
  mutating public func add(_ closure: (inout YGNode) -> Void) {
    var child = YGNode()
    let count = YGNodeGetChildCount(__node)
    closure(&child)
    YGNodeInsertChild(__node, child.__node, count)
    children.append(child)
  }

  deinit {
    YGNodeFree(__node)
  }

  public func layout(
    width: Float = YGValueUndefined.value, height: Float = YGValueUndefined.value
  ) {
    YGNodeCalculateLayout(self.__node, width, height, .LTR)
  }
}
