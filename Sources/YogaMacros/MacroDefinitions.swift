@attached(accessor)
public macro YogaValueProperty(key: String? = nil, properties: [Properties] = Properties.all) =
  #externalMacro(module: "YogaMacrosPlugin", type: "YogaValuePropertyImp")

@attached(accessor)
public macro YogaValueAutoProperty(key: String? = nil, properties: [Properties] = Properties.all) =
  #externalMacro(module: "YogaMacrosPlugin", type: "YogaValueAutoPropertyImp")

@attached(accessor)
public macro YogaValueAutoEdgeProperty(
  key: String? = nil, properties: [Properties] = Properties.all
) = #externalMacro(module: "YogaMacrosPlugin", type: "YogaValueAutoEdgePropertyImp")

@attached(accessor)
public macro YogaValueEdgeProperty(key: String? = nil, properties: [Properties] = Properties.all) =
  #externalMacro(module: "YogaMacrosPlugin", type: "YogaValueEdgePropertyImp")

@attached(accessor)
public macro YogaProperty(key: String? = nil) =
  #externalMacro(module: "YogaMacrosPlugin", type: "YogaPropertyImp")

@attached(accessor)
public macro YogaConfigProperty(key: String? = nil) =
  #externalMacro(module: "YogaMacrosPlugin", type: "YogaConfigPropertyImp")

@attached(member, names: named(stringValue))
public macro YogaStringEnum() =
  #externalMacro(module: "YogaMacrosPlugin", type: "YogaStringEnumImp")

public enum Properties {
  case min
  case max
  case auto

  public static var all: [Properties] { [.min, .max, .auto] }
}
