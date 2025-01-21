//
//  NetworkError.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case dataNotFound
    case invalidResponse
    case decodingError
}
