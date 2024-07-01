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
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.chat)
    var messages = [ChatMessage]()
    
    init(aimodel: String) {
        self.AIModel = aimodel
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
//
//@Model
//final class ModelName {
//    @Attribute(.unique) var name: String
//    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.AIModel)
//    var messages = [ChatMessage]()
//    
//    init(name: String) {
//        self.name = name
//    }
//}
