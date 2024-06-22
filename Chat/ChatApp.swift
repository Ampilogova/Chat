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
            ChatUIView(promptService: PromptServiceImpl(networkService: NetworkServiceImpl()))
        }
        .modelContainer(for: ChatMessage.self)
    }
}

//#Preview {
//    ChatUI() as! any View
//}
