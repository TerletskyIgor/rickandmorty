//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case noData
    case decodingFailed(Error)
    case badStatusCode(Int)
    case unknown
}
