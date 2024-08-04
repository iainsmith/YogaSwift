#if canImport(Darwin)
  #if canImport(UIKit)
    import UIKit
  #elseif canImport(AppKit)
    import AppKit
  #endif

  /// Experimental Apple Platforms YogaNode that uses an NSLayoutManager as the measurement function.
  public struct TextNode: YogaNode, ~Copyable {
    public var __node: YGNodeRef { yogaNode.__node }
    public var yogaNode: YGNode

    public init(yogaNode: consuming YGNode, layoutManager: NSLayoutManager) {
      self.yogaNode = yogaNode
      self.yogaNode.layoutManager = layoutManager
      self.yogaNode.setMeasurementFunc {
        (
          node: YGNodeRef?,
          width: Float, widthMode: YGMeasureMode,
          height: Float, heightMode: YGMeasureMode
        ) -> YGSize in
        /// Minimal implementation that ignores mode
        let layoutManager: NSLayoutManager = YGNodeGetContext(node).assumingMemoryBound(
          to: NSLayoutManager.self
        ).pointee
        if layoutManager.textContainers.count < 1 {
          let textContainer = NSTextContainer(
            size: .init(width: CGFloat(width), height: CGFloat(height)))
          layoutManager.addTextContainer(textContainer)
        } else {
          let textContainer = layoutManager.textContainers[0]
          textContainer.size = .init(width: CGFloat(width), height: CGFloat(height))
        }
        layoutManager.glyphRange(for: layoutManager.textContainers[0])
        let size = layoutManager.usedRect(for: layoutManager.textContainers[0])
        return YGSize(width: Float(size.width), height: Float(size.height))
      }
    }

    deinit {
      yogaNode.context.deallocate()
    }
  }

  extension YGNode {
    fileprivate var layoutManager: NSLayoutManager {
      get { context.assumingMemoryBound(to: NSLayoutManager.self).pointee }
      set {
        if context == nil {
          let pointer = UnsafeMutablePointer<NSLayoutManager>.allocate(capacity: 1)
          pointer.pointee = newValue
          context = UnsafeMutableRawPointer(pointer)
        } else {
          context.assumingMemoryBound(to: NSLayoutManager.self).pointee = newValue
        }
      }
    }
  }
#endif
