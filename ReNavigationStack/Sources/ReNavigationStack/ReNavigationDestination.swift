import Foundation
import SwiftUI

public extension View {
    func reNavigationDestination<D: Hashable, C: View>(for pathElementType: D.Type, @ViewBuilder destination builder: @escaping (D) -> C) -> some View {
        let builder = DestinationBuilder { dest in
            if let dest = dest as? D {
                return UIHostingController(rootView: builder(dest))
            }
            return nil
        }
        return modifier(DestinationBuilderModifier(builder: builder))
    }
}

public extension View {
    func reNavigationDestination<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V: View {
//        let builtDestination = AnyView(destination())
        return self

//    return modifier(
//      LocalDestinationBuilderModifier(
//        isPresented: isPresented,
//        builder: { builtDestination }
//      )
//    )
    }
}

private struct DestinationBuilderModifier: ViewModifier {
    @ObservedObject var builder: DestinationBuilder
    @Environment(\.destinationBuilderHolder) var builderHolder

    @State private var uuid = UUID()

    func body(content: Content) -> some View {
        if let builderHolder = builderHolder {
            builder.updateDestination(uuid: uuid, builderHolder: builderHolder)
        }
        return content.background(Color.red)
    }
}
