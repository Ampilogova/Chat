//
//  PromptService.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

protocol PromptService {
    func sendPrompt(text: String, modelName: String) async throws -> ChatMessage
}

class PromptServiceImpl: PromptService {
    
    private let stringUrl = "http://localhost:11434/api/generate"
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func sendPrompt(text: String, modelName: String) async throws -> ChatMessage {
        var request = NetworkRequest(url: stringUrl)
        request.httpMethod = "POST"
        request.postParameters = ["model": modelName, "prompt" : text, "stream": false]
        request.httpHeaders["Content-Type"] = "application/json"
        
        let data = try await networkService.send(request: request)
        let decoder = JSONDecoder()
        let generateResponse = try decoder.decode(GenerateResponse.self, from: data)
        let message = ChatMessage(isIncoming: true, text: generateResponse.response, chatId: modelName)
        return message
    }
}
