//
//  UIExtentions.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/21/24.
//

import SwiftUI
import SwiftData

struct ModelContainerKey: EnvironmentKey {
    static let defaultValue: ModelContainer? = nil
}

extension EnvironmentValues {
    var modelContainer: ModelContainer? {
        get { self[ModelContainerKey.self] }
        set { self[ModelContainerKey.self] = newValue }
    }
}
