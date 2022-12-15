import SwiftUI
import UIKit

struct StateObjectStorage {
    let destinationBuilderHolder = DestinationBuilderHolder()
    let pathAppender = PathAppender()
}

struct ReNavigationStackRepresent: UIViewControllerRepresentable {
    private let root: () -> UIViewController
    @State private(set) var objectStorage = StateObjectStorage()
    @Binding var path: ReNavigationPath

    init<Root: View>(path: Binding<ReNavigationPath>, root: @escaping () -> Root) {
        _path = path
        self.root = { UIHostingController(rootView: root()) }

        objectStorage.pathAppender.append = { new in
            path.wrappedValue.append(new)
        }
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.delegate = context.coordinator
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        print("updateUIViewController", path)

        if uiViewController.viewControllers.isEmpty {
            DispatchQueue.main.async {
                if uiViewController.viewControllers.isEmpty {
                    let root = self.root()
                    fixUIViewControllerLoad(root)
                    uiViewController.setViewControllers([root], animated: false)
                    updateUIViewController(uiViewController, context: context)
                }
            }
            return
        }

        let newElements = path.elements
        let oldElements = uiViewController.subHashableElements

        // Equal
        if newElements == oldElements {
            return
        }

        // Diff
        var leftViewControllers = uiViewController.viewControllers
        let root = leftViewControllers.removeFirst()
        var newViewControllers: [UIViewController] = []
        for element in newElements.reversed() {
            if let index = leftViewControllers.lastIndex(where: { $0.hashableElement == element }) {
                newViewControllers.insert(leftViewControllers.remove(at: index), at: 0)
            } else if let newViewController = objectStorage.destinationBuilderHolder.build(id: element) {
                newViewController.hashableElement = element
                newViewControllers.insert(newViewController, at: 0)
                fixUIViewControllerLoad(newViewController)
            }
        }
        newViewControllers = [root] + newViewControllers
        uiViewController.setViewControllers(newViewControllers, animated: true)

        path.elements = uiViewController.subHashableElements
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(path: $path)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate {
        @Binding var path: ReNavigationPath

        init(path: Binding<ReNavigationPath>) {
            _path = path
        }

        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            path.elements = navigationController.subHashableElements
        }
    }
}

private var hashableElementKey: UInt8 = 0
private extension UIViewController {
    var hashableElement: AnyHashable? {
        get {
            objc_getAssociatedObject(self, &hashableElementKey) as? AnyHashable
        }
        set {
            objc_setAssociatedObject(self, &hashableElementKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private extension UINavigationController {
    var subHashableElements: [AnyHashable] {
        var subViewControllers = viewControllers
        if !subViewControllers.isEmpty {
            subViewControllers.removeFirst()
        }
        return subViewControllers.compactMap(\.hashableElement)
    }
}

private func fixUIViewControllerLoad(_ viewController: UIViewController) {
    let window = UIWindow(frame: .zero)
    window.rootViewController = UINavigationController(rootViewController: viewController)
    window.isHidden = false
}
