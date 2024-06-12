//
//  ChatMessage.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/11/24.
//

import Foundation

struct ChatMessage: Codable {
    let sender: String
    let prompt: String
    let isIncoming: Bool
    let timestamp: Data
}
