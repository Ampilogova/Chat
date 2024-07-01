//
//  ChatUI.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/21/24.
//

import SwiftUI
import SwiftData

@main
struct ChatApp: App {
    var body: some Scene {
        WindowGroup {
            AIModelsListView(promptService: PromptServiceImpl(networkService: NetworkServiceImpl()))
        }
        .modelContainer(ModelContainer.shared)
    }
}

extension ModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema([
            ChatMessage.self,
            Chat.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
