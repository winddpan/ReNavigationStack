//
//  File.swift
//
//
//  Created by PAN on 2022/12/15.
//

import SwiftUI

struct DestinationBuilderHolderKey: EnvironmentKey {
    static var defaultValue: DestinationBuilderHolder?
}

struct PathAppenderKey: EnvironmentKey {
    static var defaultValue: PathAppender?
}

extension EnvironmentValues {
    var destinationBuilderHolder: DestinationBuilderHolder? {
        get { self[DestinationBuilderHolderKey.self] }
        set { self[DestinationBuilderHolderKey.self] = newValue }
    }

    var pathAppender: PathAppender? {
        get { self[PathAppenderKey.self] }
        set { self[PathAppenderKey.self] = newValue }
    }
}
