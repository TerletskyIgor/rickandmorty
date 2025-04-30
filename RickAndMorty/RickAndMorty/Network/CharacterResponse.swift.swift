//
//  CharacterResponse.swift.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

struct CharacterResponse: Decodable {
    let info: PageInfo
    let results: [Character]
}

struct PageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String
}

