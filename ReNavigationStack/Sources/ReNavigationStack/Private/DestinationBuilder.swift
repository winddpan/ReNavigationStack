import SwiftUI

class DestinationBuilder: ObservableObject {
    private weak var builderHolder: DestinationBuilderHolder?
    private let builder: (AnyHashable) -> UIViewController?
    private var uuid: UUID?
    
    deinit {
        if let uuid = uuid, let builderHolder = builderHolder {
            builderHolder.removeBuilder(for: uuid)
        }
    }
    
    init(_ builder: @escaping (AnyHashable) -> UIViewController?) {
        self.builder = builder
    }
    
    func updateDestination(uuid: UUID, builderHolder: DestinationBuilderHolder) {
        self.builderHolder = builderHolder
        self.uuid = uuid
        builderHolder.appendBuilder(uuid: uuid, builder: builder)
    }
}

class DestinationBuilderHolder: ObservableObject {
    class Holder {
        let builder: (AnyHashable) -> UIViewController?
        
        init(builder: @escaping (AnyHashable) -> UIViewController?) {
            self.builder = builder
        }
    }
    
    private var builderMap: [UUID: Holder] = [:]
    private var builderArray: [Holder] = []
    
    func appendBuilder(uuid: UUID, builder: @escaping (AnyHashable) -> UIViewController?) {
        removeBuilder(for: uuid)
        
        let holder = Holder(builder: builder)
        builderMap[uuid] = holder
        builderArray.append(holder)
    }

    func removeBuilder(for uuid: UUID) {
        if let old = builderMap[uuid] {
            builderMap.removeValue(forKey: uuid)
            builderArray.removeAll(where: { $0 === old })
        }
    }
    
    func build(id: any Hashable) -> UIViewController? {
        for holder in builderArray.reversed() {
            if let view = holder.builder(AnyHashable(id)) {
                return view
            }
        }
        return nil
    }
}
