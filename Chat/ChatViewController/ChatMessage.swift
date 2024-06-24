//
//  ChatMessage.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/11/24.
//

import Foundation
import SwiftData

@Model 
class ChatMessage:  ObservableObject, Identifiable {
    let AIModel: ModelName?
    let isIncoming: Bool
    let text: String
    var id = UUID()
    
    init(isIncoming: Bool, text: String ) {
        self.isIncoming = isIncoming
        self.text = text
        self.id = id
    }
}

@Model
final class ModelName {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.AIModel)
    var messages = [ChatMessage]()
    
    init(name: String) {
        self.name = name
    }
}
