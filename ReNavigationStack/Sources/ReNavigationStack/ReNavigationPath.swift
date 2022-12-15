import SwiftUI

public struct ReNavigationPathKey: EnvironmentKey {
    public static var defaultValue: ReNavigationPath?
}

public extension EnvironmentValues {
    var reNavigationPath: ReNavigationPath? {
        get { self[ReNavigationPathKey.self] }
        set { self[ReNavigationPathKey.self] = newValue }
    }
}

public struct ReNavigationPath {
    var elements: [AnyHashable]

    public var count: Int {
        elements.count
    }

    public var isEmpty: Bool {
        elements.isEmpty
    }

    public var codable: ReNavigationPath.CodableRepresentation? {
        fatalError()
    }

    public init() {
        elements = []
    }

    public init<S>(_ elements: S) where S: Sequence, S.Element: Hashable {
        self.elements = elements.map { $0 as AnyHashable }
    }

    public init(_ codable: ReNavigationPath.CodableRepresentation) {
        fatalError()
    }

    public mutating func append<V>(_ value: V) where V: Hashable {
        elements.append(value as AnyHashable)
    }

    public mutating func removeLast(_ k: Int = 1) {
        elements.removeLast(k)
    }

    public struct CodableRepresentation: Codable {
        public init(from decoder: Decoder) throws {
            fatalError()
        }

        public func encode(to encoder: Encoder) throws {
            fatalError()
        }
    }
}

extension ReNavigationPath: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(elements)
    }

    public static func == (lhs: ReNavigationPath, rhs: ReNavigationPath) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension ReNavigationPath.CodableRepresentation: Equatable {
    public static func == (lhs: ReNavigationPath.CodableRepresentation, rhs: ReNavigationPath.CodableRepresentation) -> Bool {
        fatalError()
    }
}
