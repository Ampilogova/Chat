//
//  ChatMessage.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/11/24.
//

import Foundation
import SwiftData

@Model
class Chat: Identifiable {
    let id = UUID()
    let AIModel: String
    let title: String
    
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.chat)
    var messages = [ChatMessage]()
    
    init(aimodel: String, title: String) {
        self.AIModel = aimodel
        self.title = title
    }
}

@Model
class ChatMessage:  ObservableObject, Identifiable {
    let isIncoming: Bool
    let text: String
    let chat: Chat
    
    init(isIncoming: Bool, text: String, chat: Chat) {
        self.isIncoming = isIncoming
        self.text = text
        self.chat = chat
    }
}
