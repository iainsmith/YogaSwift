import yoga

/// A ``YogaNode`` that owns the ``YogaNode/node`` and will free it on deinit.
public struct YGNode: YogaNode, ~Copyable {
  public let __node: YGNodeRef

  // Directly crated children that need to be released.
  private var ownedChildren: [YGNodeRef] = []

  public init(configuration: borrowing YogaConfiguration) {
    self.__node = YGNodeNewWithConfig(configuration.config)
  }

  public init() {
    self.__node = YGNodeNew()
  }

  public init(from node: consuming YGNodeRef) {
    self.__node = node
  }

  /// Add a child at the last index that will be owned by this ``Node``
  mutating public func add(_ closure: (inout YGNodeView) -> Void) {
    guard let child = YGNodeNew() else { return }
    ownedChildren.append(child)
    let count = YGNodeGetChildCount(__node)
    var ref = YGNodeView(from: child)
    closure(&ref)
    YGNodeInsertChild(__node, child, count)
  }

  deinit {
    for child in ownedChildren {
      YGNodeFree(child)
    }
    YGNodeFree(__node)
  }

  public func children(_ closure: (inout YGNodeView) -> Void) {
    YGNodeView(from: __node).children(closure)
  }

  public func walk(_ closure: (inout YGNodeView) -> Void) {
    YGNodeView(from: __node).walk(closure)
  }

  public func layout(
    width: Float = YGValueUndefined.value, height: Float = YGValueUndefined.value
  ) {
    YGNodeCalculateLayout(self.__node, width, height, .LTR)
  }
}
