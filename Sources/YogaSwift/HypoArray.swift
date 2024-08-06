/// Hypoarray from https://github.com/swiftlang/swift/blob/5424ddd051bebeefc143d5c227b324a82266bfa1/test/Prototypes/Hypoarray.swift#L20
public struct Hypoarray<Element: ~Copyable>: ~Copyable {
  private var _storage: UnsafeMutableBufferPointer<Element>
  private var _count: Int

  var capacity: Int { _storage.count }

  init() {
    _storage = .init(start: nil, count: 0)
    _count = 0
  }

  init(_ element: consuming Element) {
    _storage = .allocate(capacity: 1)
    _storage.initializeElement(at: 0, to: element)
    _count = 1
  }

  init(count: Int, initializedBy generator: (Int) -> Element) {
    _storage = .allocate(capacity: count)
    for i in 0..<count {
      _storage.initializeElement(at: i, to: generator(i))
    }
    _count = count
  }

  deinit {
    _storage.extracting(0..<count).deinitialize()
    _storage.deallocate()
  }
}

extension Hypoarray: @unchecked Sendable where Element: Sendable & ~Copyable {}

extension Hypoarray where Element: ~Copyable {
  typealias Index = Int

  var isEmpty: Bool { _count == 0 }
  var count: Int { _count }

  var startIndex: Int { 0 }
  var endIndex: Int { _count }
  func index(after i: Int) -> Int { i + 1 }
  func index(before i: Int) -> Int { i - 1 }
  func distance(from start: Int, to end: Int) -> Int { end - start }
  // etc.
}

extension Hypoarray where Element: ~Copyable {
  mutating func forEach(_ closure: (inout Element) -> Void) {
    var index = startIndex
    while index < count {
      updateElement(at: index) { element in closure(&element) }
      index += 1
    }
  }
}

extension UnsafeMutableBufferPointer where Element: ~Copyable {
  @_alwaysEmitIntoClient
  public func extracting(_ bounds: Range<Int>) -> Self {
    guard let start = self.baseAddress else {
      return Self(start: nil, count: 0)
    }
    return Self(start: start + bounds.lowerBound, count: bounds.count)
  }

  @_alwaysEmitIntoClient
  public func extracting(_ bounds: some RangeExpression<Int>) -> Self {
    extracting(bounds.relative(to: Range(uncheckedBounds: (0, count))))
  }

  @_alwaysEmitIntoClient
  public func extracting(_ bounds: UnboundedRange) -> Self {
    self
  }
}

extension Hypoarray where Element: ~Copyable {
  func borrowElement<E: Error, R: ~Copyable>(
    at index: Int,
    by body: (borrowing Element) throws(E) -> R
  ) throws(E) -> R {
    precondition(index >= 0 && index < _count)
    return try body(_storage[index])
  }

  mutating func updateElement<E: Error, R: ~Copyable>(
    at index: Int,
    by body: (inout Element) throws(E) -> R
  ) throws(E) -> R {
    precondition(index >= 0 && index < _count)
    return try body(&_storage[index])
  }
}

extension Hypoarray where Element: ~Copyable {
  subscript(position: Int) -> Element {
    _read {
      precondition(position >= 0 && position < _count)
      yield _storage[position]
    }
    _modify {
      precondition(position >= 0 && position < _count)
      yield &_storage[position]
    }
  }
}

extension Hypoarray where Element: ~Copyable {
  @discardableResult
  mutating func remove(at index: Int) -> Element {
    precondition(index >= 0 && index < count)
    let old = _storage.moveElement(from: index)
    let source = _storage.extracting(index + 1..<count)
    let target = _storage.extracting(index..<count - 1)
    let i = target.moveInitialize(fromContentsOf: source)
    assert(i == target.endIndex)
    _count -= 1
    return old
  }
}

extension Hypoarray where Element: ~Copyable {
  mutating func reserveCapacity(_ n: Int) {
    guard capacity < n else { return }
    let newStorage: UnsafeMutableBufferPointer<Element> = .allocate(capacity: n)
    let source = _storage.extracting(0..<count)
    let i = newStorage.moveInitialize(fromContentsOf: source)
    assert(i == count)
    _storage.deallocate()
    _storage = newStorage
  }
}

extension Hypoarray where Element: ~Copyable {
  mutating func _ensureFreeCapacity(_ minimumCapacity: Int) {
    guard capacity < _count + minimumCapacity else { return }
    reserveCapacity(max(_count + minimumCapacity, 2 * capacity))
  }
}

extension Hypoarray where Element: ~Copyable {
  mutating func append(_ item: consuming Element) {
    _ensureFreeCapacity(1)
    _storage.initializeElement(at: _count, to: item)
    _count += 1
  }
}

extension Hypoarray where Element: ~Copyable {
  mutating func insert(_ item: consuming Element, at index: Int) {
    precondition(index >= 0 && index <= count)
    _ensureFreeCapacity(1)
    if index < count {
      let source = _storage.extracting(index..<count)
      let target = _storage.extracting(index + 1..<count + 1)
      let last = target.moveInitialize(fromContentsOf: source)
      assert(last == target.endIndex)
    }
    _storage.initializeElement(at: index, to: item)
    _count += 1
  }
}

extension Hypoarray {
  mutating func append(contentsOf items: some Sequence<Element>) {
    for item in items {
      append(item)
    }
  }
}
