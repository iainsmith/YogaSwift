import YogaSwift

@main
struct CLI {
  static func main() {
    var root = YGNode()
    root.direction = .LTR
    root.flexDirection = .row
    root.width = .init(value: 100, unit: .point)
    root.height = .init(value: 100, unit: .point)

    var child0 = YGNode()
    child0.flexGrow = 1.0
    child0.rightMargin = .init(value: 10, unit: .point)
    var child1 = YGNode()
    child1.flexGrow = 1.0
    root.add(child0)
    root.add(child1)

    root.layout()

  }
}
