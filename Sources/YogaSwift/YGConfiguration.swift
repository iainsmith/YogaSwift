import YogaMacros
import yoga

/// A ``YogaConfiguration`` that owns the ``YogaNode/config`` and will free it on deinit.
public struct YGConfiguration: YogaConfiguration, ~Copyable {
  public let config: YGConfigRef

  init(config: YGConfigRef) {
    self.config = config
  }

  deinit {
    YGConfigFree(config)
  }
}
