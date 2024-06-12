//
//  NetworkService.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/5/24.
//

import Foundation

public protocol NetworkService {
    func send(request: NetworkRequest, completion: @escaping (Result<Data,Error>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    
    let urlSession = URLSession.shared
    
    
    func send(request: NetworkRequest, completion: @escaping (Result <Data, Error>) -> Void) {
        guard let url = URL(string: request.url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        for (key, value) in request.httpHeaders {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if request.httpMethod == "POST" {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.postParameters, options: [])
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let dataTask = urlSession.dataTask(with: urlRequest) { data, responce, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "Error", code: -1)))
            }
        }
        dataTask.resume()
    }
}
