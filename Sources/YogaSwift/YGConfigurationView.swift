import YogaMacros
import yoga

public struct YGConfigurationView: YogaConfiguration, ~Copyable {
  public let config: YGConfigConstRef

  init(config: consuming YGConfigRef) {
    self.config = config
  }
}
