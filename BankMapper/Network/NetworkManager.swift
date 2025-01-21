//
//  NetworkManager.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import Foundation
import SwiftUI

// MARK: - NetworkAction Protocol
protocol NetworkAction {
    func get(apiURL: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

// MARK: - NetworkManager Implementation
struct NetworkManager: NetworkAction {
    private let urlSession: URLSession
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func get(apiURL: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.dataNotFound))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
