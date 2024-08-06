import YogaMacros
import yoga.core

/// Conforming types:
///   - have accessors generated for the underlying YGNodeRef
///   - that allocate the YGNodeRef are responsible for callign YGNodeFree on the node in deinit
///
///  Users should not call YGNodeFree on ``Node`` or ``NodeView``
public protocol YogaNode: ~Copyable {

  /// Users should avoid accessing this property directly
  var __node: YGNodeRef { get }

  var children: Hypoarray<Self> { get set }
  //  var children: Hypoarray<any YogaNode & ~Copyable> { get set }
}

extension YogaNode where Self: ~Copyable {
  //  public func parent(_ closure: (inout YGNode) -> Void) {
  //    if let parent = YGNodeGetParent(__node) {
  //      var node: YGNodeView = YGNodeView(from: parent)
  //      closure(&node)
  //    }
  //  }

  public mutating func children(_ closure: (inout Self) -> Void) {
    children.forEach(closure)
  }

  public mutating func walk(_ closure: (inout Self) -> Void) {
    var a: Self = self
    closure(&a)
    a.children { node in
      closure(&node)
    }
    self = a
  }

  public var context: UnsafeMutableRawPointer! {
    get { YGNodeGetContext(__node) }
    set { YGNodeSetContext(__node, newValue) }
  }

  public var config: YGConfigurationView {
    get { YGConfigurationView(config: YGNodeGetConfig(__node)) }
    set { YGNodeSetConfig(__node, newValue.config) }
  }

  //  public func add<N: YogaNode & ~Copyable>(_ child: borrowing N) {
  //    let count = YGNodeGetChildCount(__node)
  //    YGNodeInsertChild(__node, child.__node, count)
  //  }

  public func remove(_ child: borrowing YGNode) {
    YGNodeRemoveChild(__node, child.__node)
  }

  public func removeAllChildren() {
    YGNodeRemoveAllChildren(__node)
  }

  public var hasNewLayout: Bool {
    get { YGNodeGetHasNewLayout(__node) }
    set { YGNodeSetHasNewLayout(__node, newValue) }
  }

  public func reset() {
    YGNodeReset(__node)
  }

  public var isDirty: Bool {
    get { YGNodeIsDirty(__node) }
    set {
      if hasMeasureFunc {
        YGNodeMarkDirty(__node)
      }
    }
  }

  public var nodeType: YGNodeType {
    get { YGNodeGetNodeType(__node) }
    set { YGNodeSetNodeType(__node, newValue) }
  }

  // MARK: Measurement

  public var hasMeasureFunc: Bool { YGNodeHasMeasureFunc(__node) }

  public func setMeasurementFunc(_ measure: Measurement) { YGNodeSetMeasureFunc(__node, measure) }

  // MARK: Style

  @YogaProperty(key: "PositionType")
  public var position: YGPositionType

  @YogaProperty
  public var display: YGDisplay

  @YogaProperty
  public var flexWrap: YGWrap

  @YogaValueAutoProperty
  public var flexBasis: YGValue

  @YogaProperty
  public var flexShrink: Float

  @YogaProperty
  public var flex: Float

  @YogaProperty
  public var flexGrow: Float

  @YogaProperty
  public var overflow: YGOverflow

  @YogaProperty
  public var flexDirection: YGFlexDirection

  @YogaProperty
  public var direction: YGDirection

  @YogaProperty
  public var justifyContent: YGJustify

  @YogaProperty
  public var alignContent: YGAlign

  @YogaProperty
  public var alignItems: YGAlign

  @YogaProperty
  public var alignSelf: YGAlign

  @YogaValueAutoProperty
  public var width: YGValue

  @YogaValueProperty
  public var minWidth: YGValue

  @YogaValueProperty
  public var maxWidth: YGValue

  @YogaValueAutoProperty
  public var height: YGValue

  @YogaValueProperty
  public var minHeight: YGValue

  @YogaValueProperty
  public var maxHeight: YGValue

  @YogaProperty
  public var aspectRatio: Float

  @YogaValueAutoEdgeProperty(key: "left")
  public var leftMargin: YGValue
  @YogaValueAutoEdgeProperty(key: "right")
  public var rightMargin: YGValue
  @YogaValueAutoEdgeProperty(key: "top")
  public var topMargin: YGValue
  @YogaValueAutoEdgeProperty(key: "bottom")
  public var bottomMargin: YGValue
  @YogaValueAutoEdgeProperty(key: "start")
  public var startMargin: YGValue
  @YogaValueAutoEdgeProperty(key: "end")
  public var endMargin: YGValue

  @YogaValueEdgeProperty(key: "left")
  public var leftPadding: YGValue
  @YogaValueEdgeProperty(key: "right")
  public var rightPadding: YGValue
  @YogaValueEdgeProperty(key: "top")
  public var topPadding: YGValue
  @YogaValueEdgeProperty(key: "bottom")
  public var bottomPadding: YGValue
  @YogaValueEdgeProperty(key: "start")
  public var startPadding: YGValue
  @YogaValueEdgeProperty(key: "end")
  public var endPadding: YGValue

  @YogaValueEdgeProperty(key: "left")
  public var leftBorder: Float
  @YogaValueEdgeProperty(key: "right")
  public var rightBorder: Float
  @YogaValueEdgeProperty(key: "top")
  public var topBorder: Float
  @YogaValueEdgeProperty(key: "bottom")
  public var bottomBorder: Float
  @YogaValueEdgeProperty(key: "start")
  public var startBorder: Float
  @YogaValueEdgeProperty(key: "end")
  public var endBorder: Float

  // MARK: Layout

  public var layoutLeft: Float { YGNodeLayoutGetLeft(__node) }
  public var layoutRight: Float { YGNodeLayoutGetRight(__node) }
  public var layoutTop: Float { YGNodeLayoutGetTop(__node) }
  public var layoutBottom: Float { YGNodeLayoutGetBottom(__node) }
  public var layoutWidth: Float { YGNodeLayoutGetWidth(__node) }
  public var layoutHeight: Float { YGNodeLayoutGetHeight(__node) }
  public var layoutDirection: YGDirection { YGNodeLayoutGetDirection(__node) }

  public func layoutMargin(for edge: YGEdge) -> Float { YGNodeLayoutGetMargin(__node, edge) }
  public func layoutBorder(for edge: YGEdge) -> Float { YGNodeLayoutGetBorder(__node, edge) }
  public func layoutPadding(for edge: YGEdge) -> Float { YGNodeLayoutGetPadding(__node, edge) }

  static func copyStyle(from: borrowing some YogaNode, to: borrowing some YogaNode) {
    YGNodeCopyStyle(to.__node, from.__node)
  }
}

public typealias Measurement = @convention(c) (
  _ node: YGNodeRef?, _ width: Float, _ widthMode: YGMeasureMode, _ height: Float,
  _ heightMode: YGMeasureMode
) -> YGSize
