import YogaMacros
import yoga

public protocol YogaConfiguration: ~Copyable {
  var config: YGConfigRef { get }
}

extension YogaConfiguration {
  @YogaConfigProperty
  public var useWebDefaults: Bool

  @YogaConfigProperty
  public var pointScaleFactor: Float

  @YogaConfigProperty
  public var errata: YGErrata

  @YogaConfigProperty
  public var context: UnsafeMutableRawPointer?

  public func setLogger(_ logger: YGLogger) {
    YGConfigSetLogger(config, logger)
  }

  public func setExperimental(_ feature: YGExperimentalFeature, isEnabled: Bool) {
    YGConfigSetExperimentalFeatureEnabled(config, feature, isEnabled)
  }

  public func featureIsEnabled(_ feature: YGExperimentalFeature) -> Bool {
    YGConfigIsExperimentalFeatureEnabled(config, feature)
  }

  public func setCloneNodeFunc(_ closure: YGCloneNodeFunc) {
    YGConfigSetCloneNodeFunc(config, closure)
  }
}
