//
//  PromptService.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

protocol PromptService {
    func sendPrompt(text: String, completion: @escaping (Result<ChatMessage, Error>) -> Void)
}

class PromptServiceImpl: PromptService {
    
    private let stringUrl = "http://localhost:11434/api/generate"
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func sendPrompt(text: String, completion: @escaping (Result<ChatMessage, any Error>) -> Void) {
        var request = NetworkRequest(url: stringUrl)
        request.httpMethod = "POST"
        request.postParameters = ["model": "tinyllama", "prompt" : text, "stream": false]
        request.httpHeaders["Content-Type"] = "application/json" //"gemma:2b"

        networkService.send(request: request) { result in
            switch result {
            case .success(let data):
                let answer = try? JSONDecoder().decode(ChatMessage.self, from: data)
                if let answer = answer {
                    completion(.success(answer))
                }
                
                
            case .failure(_):
                completion(.failure(NSError(domain: "Error", code: -1)))
            }
        }
    }
}
