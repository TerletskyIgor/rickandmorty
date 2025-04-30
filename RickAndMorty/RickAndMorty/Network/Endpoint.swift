//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var urlRequest: URLRequest? { get }
}

extension Endpoint {
    var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path += path
        components?.queryItems = queryItems
        guard let url = components?.url else { return nil }
        return URLRequest(url: url)
    }
}
