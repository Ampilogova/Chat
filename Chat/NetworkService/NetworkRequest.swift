//
//  NetworkRequest.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

public struct NetworkRequest {
    var url: String
    var httpMethod = "GET"
    var parameters = [String: String]()
    var postParameters: [String: Any]?
    var httpHeaders = [String: String]()
    
    var data: Data? {
        guard let postParameters = postParameters else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: postParameters, options: [])
    }
    
    init(url: String) {
        self.url = url
    }
    
    func buildURLRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        guard let url = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = data
        
        return request
    }
}
