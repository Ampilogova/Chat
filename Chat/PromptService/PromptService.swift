//
//  PromptService.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

protocol PromptService {
    func sendPrompt(text: String, completion: @escaping (Result<String, Error>) -> Void)
}

class PromptServiceImpl: PromptService {
    
    private let stringUrl = "http://localhost:11434/api/generate"
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func sendPrompt(text: String, completion: @escaping (Result<String, any Error>) -> Void) {
        var request = NetworkRequest(url: stringUrl)
        request.httpMethod = "POST"
        request.postParameters = ["model": "gemma:2b", "prompt" : text, "stream": false]
        request.httpHeaders["Content-Type"] = "application/json"

        networkService.send(request: request) { result in
            switch result {
            case .success(let data):
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonDict = jsonObject as? [String: Any],
                   let response  = jsonDict["response"] as? String {
                    completion(.success(response))
                } else {
                    completion(.failure(NSError(domain: "Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            case .failure(_):
                completion(.failure(NSError(domain: "Error", code: -1)))
            }
        }
    }
}
