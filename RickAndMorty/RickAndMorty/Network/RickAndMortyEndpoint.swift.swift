//
//  RickAndMortyEndpoint.swift.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

struct RickAndMortyEndpoint: Endpoint {
    var baseURL: String { "https://rickandmortyapi.com/api" }
    var path: String
    var queryItems: [URLQueryItem]

    static func characters(page: Int = 1) -> RickAndMortyEndpoint {
        return RickAndMortyEndpoint(
            path: "/character",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        )
    }
}
