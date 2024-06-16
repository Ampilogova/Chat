//
//  ChatMessage.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/11/24.
//

import Foundation

struct ChatMessage: Codable {
    let isIncoming: Bool
    let response: String
}
