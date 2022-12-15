import SwiftUI
import UIKit

@MainActor public struct ReNavigationStack<Data, Root>: View where Root: View {
    private let represent: ReNavigationStackRepresent

    @MainActor public init(path: Binding<ReNavigationPath>, @ViewBuilder root: @escaping () -> Root) where Data == ReNavigationPath {
        represent = .init(path: path, root: root)
    }

    @MainActor public init(@ViewBuilder root: @escaping () -> Root) where Data == ReNavigationPath {
        // TODO: wrong! .constant(.init())
        represent = .init(path: .constant(.init()), root: root)
    }

    @MainActor public init(path: Binding<Data>, @ViewBuilder root: @escaping () -> Root) where Data: MutableCollection, Data: RandomAccessCollection, Data: RangeReplaceableCollection, Data.Element: Hashable {
        let binding = Binding<ReNavigationPath>.init(get: {
            ReNavigationPath(path.wrappedValue)
        }, set: {
            if let data = $0.elements as? Data {
                path.wrappedValue = data
            }
        })
        represent = .init(path: binding, root: root)
    }

    @MainActor public var body: some View {
        return represent
            .edgesIgnoringSafeArea(.all)
            .environment(\.reNavigationPath, represent.path)
            .environment(\.destinationBuilderHolder, represent.objectStorage.destinationBuilderHolder)
            .environment(\.pathAppender, represent.objectStorage.pathAppender)
    }
}
