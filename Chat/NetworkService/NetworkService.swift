//
//  NetworkService.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

public protocol NetworkService {
    func send(request: NetworkRequest) async throws -> Data
}

class NetworkServiceImpl: NetworkService {
    
    let urlSession = URLSession.shared
    
    func send(request: NetworkRequest) async throws -> Data {
        guard let urlRequest = request.buildURLRequest() else {
            throw URLError(.badURL)
        }
        let (data, _) = try await urlSession.data(for: urlRequest)
        return data
    }
}
