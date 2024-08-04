import YogaMacros
import yoga

@YogaStringEnum
extension YGAlign {}

@YogaStringEnum
extension YGDimension {}

@YogaStringEnum
extension YGDirection {}

@YogaStringEnum
extension YGDisplay {}

@YogaStringEnum
extension YGEdge {}

@YogaStringEnum
extension YGErrata {}

@YogaStringEnum
extension YGExperimentalFeature {}

@YogaStringEnum
extension YGFlexDirection {}

@YogaStringEnum
extension YGGutter {}

@YogaStringEnum
extension YGJustify {}

@YogaStringEnum
extension YGLogLevel {}

@YogaStringEnum
extension YGMeasureMode {}

@YogaStringEnum
extension YGNodeType {}

@YogaStringEnum
extension YGOverflow {}

@YogaStringEnum
extension YGPositionType {}

@YogaStringEnum
extension YGUnit {}

@YogaStringEnum
extension YGWrap {}

extension YGValue {
  public static var auto: YGValue { YGValueAuto }
  public static var zero: YGValue { YGValueZero }
  public static var undefined: YGValue { YGValueUndefined }
}

extension YGSize {
  public static var zero: YGSize { .init() }
}
