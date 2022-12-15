import SwiftUI

public struct ReNavigationLink<Label, Destination>: View where Label: View, Destination: View {
    @Environment(\.pathAppender) var pathAppender

    var value: AnyHashable?
    var label: Label

    public var body: some View {
        Button(
            action: {
                guard let value = value else { return }
                pathAppender?.append?(value)
            },
            label: { label }
        )
        .buttonStyle(.plain)
    }
}

public extension ReNavigationLink where Destination == Never {
    init<P>(value: P?, @ViewBuilder label: () -> Label) where P: Hashable {
        self.value = value
        self.label = label()
    }

    init<P>(_ titleKey: LocalizedStringKey, value: P?) where Label == Text, P: Hashable {
        self.value = value
        self.label = Text(titleKey)
    }

    init<S, P>(_ title: S, value: P?) where Label == Text, S: StringProtocol, P: Hashable {
        self.value = value
        self.label = Text(title)
    }
}
