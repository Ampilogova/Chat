//
//  PromptService.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

protocol PromptService {
    func sendPrompt(text: String) async throws -> ChatMessage
}

class PromptServiceImpl: PromptService {
    
    private let stringUrl = "http://localhost:11434/api/generate"
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func sendPrompt(text: String) async throws -> ChatMessage {
        var request = NetworkRequest(url: stringUrl)
        request.httpMethod = "POST"
        request.postParameters = ["model": "tinyllama", "prompt" : text, "stream": false]
        request.httpHeaders["Content-Type"] = "application/json" //gemma:2b
        
        let data = try await networkService.send(request: request)
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = jsonObject as? [String: Any],
              let response  = jsonDict["response"] as? String else {
            throw NSError(domain: "Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }
        
        let message = ChatMessage(isIncoming: true, response: response)
        return message
    }
}
