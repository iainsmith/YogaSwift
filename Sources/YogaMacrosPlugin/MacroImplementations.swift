import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct YogaMacros: CompilerPlugin {
  var providingMacros: [Macro.Type] = [
    YogaPropertyImp.self,
    YogaValuePropertyImp.self,
    YogaValueAutoPropertyImp.self,
    YogaValueAutoEdgePropertyImp.self,
    YogaValueEdgePropertyImp.self,
    YogaConfigPropertyImp.self,
    YogaStringEnumImp.self,
  ]
}

public struct YogaStringEnumImp: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let ext = declaration.as(ExtensionDeclSyntax.self)
    else {
      return []
    }
    let name = ext.extendedType.trimmed

    return ["public var stringValue: String { return String(cString: \(raw: name)ToString(self)) }"]
  }
}

public struct YogaConfigPropertyImp: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    let property: String
    if case let .argumentList(values) = node.arguments,
      let segments = values.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
      case let .stringSegment(string) = segments.first
    {
      property = string.content.text
    } else {
      guard
        let pattern = declaration.as(VariableDeclSyntax.self)?.bindings.first?.pattern
          .trimmedDescription
      else {
        throw CancellationError()
      }
      property = pattern.firstUppercased
    }

    let getAccessor: AccessorDeclSyntax =
      """
      get { YGConfigGet\(raw: property)(self.config) }
      """

    let setAccessor: AccessorDeclSyntax =
      """
      set { YGConfigSet\(raw: property)(self.config, newValue) }
      """

    return [getAccessor, setAccessor]
  }
}

public struct YogaPropertyImp: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    let property: String
    if case let .argumentList(values) = node.arguments,
      let segments = values.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
      case let .stringSegment(string) = segments.first
    {
      property = string.content.text
    } else {
      guard
        let pattern = declaration.as(VariableDeclSyntax.self)?.bindings.first?.pattern
          .trimmedDescription
      else {
        throw CancellationError()
      }
      property = pattern.firstUppercased
    }

    let getAccessor: AccessorDeclSyntax =
      """
      get { YGNodeStyleGet\(raw: property)(self.__node) }
      """

    let setAccessor: AccessorDeclSyntax =
      """
      set { YGNodeStyleSet\(raw: property)(self.__node, newValue) }
      """

    return [getAccessor, setAccessor]
  }
}

public struct YogaValuePropertyImp: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    let property: String
    if case let .argumentList(values) = node.arguments,
      let segments = values.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
      case let .stringSegment(string) = segments.first
    {
      property = string.content.text
    } else {
      guard
        let pattern = declaration.as(VariableDeclSyntax.self)?.bindings.first?.pattern
          .trimmedDescription
      else {
        throw CancellationError()
      }
      property = pattern.firstUppercased
    }

    let getAccessor: AccessorDeclSyntax =
      """
      get { YGNodeStyleGet\(raw: property)(self.__node) }
      """

    let setAccessor: AccessorDeclSyntax =
      """
      set {
         switch newValue.unit {
            case .auto:
                break
            case .percent:
                YGNodeStyleSet\(raw: property)Percent(__node, newValue.value)
            case .point:
                YGNodeStyleSet\(raw: property)(__node, newValue.value)
            case .undefined:
                break
            default:
                break
            }
      }
      """

    return [getAccessor, setAccessor]
  }
}

public struct YogaValueAutoPropertyImp: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    let property: String
    if case let .argumentList(values) = node.arguments,
      let segments = values.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
      case let .stringSegment(string) = segments.first
    {
      property = string.content.text
    } else {
      guard
        let pattern = declaration.as(VariableDeclSyntax.self)?.bindings.first?.pattern
          .trimmedDescription
      else {
        throw CancellationError()
      }
      property = pattern.firstUppercased
    }

    let getAccessor: AccessorDeclSyntax =
      """
      get { YGNodeStyleGet\(raw: property)(self.__node) }
      """

    let setAccessor: AccessorDeclSyntax =
      """
      set {
         switch newValue.unit {
            case .auto:
                YGNodeStyleSet\(raw: property)Auto(__node)
            case .percent:
                YGNodeStyleSet\(raw: property)Percent(__node, newValue.value)
            case .point:
                YGNodeStyleSet\(raw: property)(__node, newValue.value)
            case .undefined:
                break
            default:
                break
            }
      }
      """

    return [getAccessor, setAccessor]
  }
}

public struct YogaValueEdgePropertyImp: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {

    guard case let .argumentList(values) = node.arguments,
      let segments = values.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
      case let .stringSegment(string) = segments.first,
      let binding = declaration.as(VariableDeclSyntax.self)?.bindings.first,
      let type = binding.typeAnnotation?.type.trimmedDescription
    else {
      throw CancellationError()
    }

    let pattern = binding.pattern.trimmedDescription
    let property = pattern.drop(while: { $0.isLowercase })
    let key = string.content.text

    let getAccessor: AccessorDeclSyntax =
      """
      get { YGNodeStyleGet\(raw: property)(self.__node, .\(raw: key)) }
      """

    let setAccessor: AccessorDeclSyntax
    if type == "YGValue" {
      setAccessor = """
        set {
           switch newValue.unit {
              case .auto:
                  break
              case .percent:
                  YGNodeStyleSet\(raw: property)Percent(__node, .\(raw: key), newValue.value)
              case .point:
                  YGNodeStyleSet\(raw: property)(__node, .\(raw: key), newValue.value)
              case .undefined:
                  break
              default:
                  break
              }
        }
        """
    } else {
      setAccessor = """
        set { YGNodeStyleSet\(raw: property)(self.__node, .\(raw: key), newValue) }
        """
    }

    return [getAccessor, setAccessor]
  }
}

public struct YogaValueAutoEdgePropertyImp: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {

    guard case let .argumentList(values) = node.arguments,
      let segments = values.first?.expression.as(StringLiteralExprSyntax.self)?.segments,
      case let .stringSegment(string) = segments.first,
      let pattern = declaration.as(VariableDeclSyntax.self)?.bindings.first?.pattern
        .trimmedDescription
    else {
      throw CancellationError()
    }

    let property = pattern.drop(while: { $0.isLowercase })
    let key = string.content.text

    let getAccessor: AccessorDeclSyntax =
      """
      get { YGNodeStyleGet\(raw: property)(self.__node, .\(raw: key)) }
      """

    let setAccessor: AccessorDeclSyntax =
      """
      set {
         switch newValue.unit {
            case .auto:
                YGNodeStyleSet\(raw: property)Auto(__node, .\(raw: key))
            case .percent:
                YGNodeStyleSet\(raw: property)Percent(__node, .\(raw: key), newValue.value)
            case .point:
                YGNodeStyleSet\(raw: property)(__node, .\(raw: key), newValue.value)
            case .undefined:
                break
            default:
                break
            }
      }
      """

    return [getAccessor, setAccessor]
  }
}

extension StringProtocol {
  var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
