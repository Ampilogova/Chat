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
    let isIncoming: Bool
    let text: String
    var id = UUID()
    
    init(isIncoming: Bool, text: String) {
        self.isIncoming = isIncoming
        self.text = text
        self.id = id
    }
}
