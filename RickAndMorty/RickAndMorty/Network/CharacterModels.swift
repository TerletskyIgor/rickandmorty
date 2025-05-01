//
//  CharacterModels.swift.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

struct PageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Decodable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case imageURL = "image"
    }
}

struct CharacterResponse: Decodable {
    let info: PageInfo
    let results: [Character]
}

extension Character {
    init(from cdCharacter: CDCharacter) {
        self.init(id: Int(cdCharacter.id),
                  name: cdCharacter.name ?? "Unknown",
                  status: cdCharacter.status ?? "Unknown",
                  species: cdCharacter.species ?? "Unknown",
                  imageURL: cdCharacter.imageURL ?? "Unknown"
        )
    }
}

extension CDCharacter {
    func update(from character: Character) {
        self.id = Int32(character.id)
        self.name = character.name 
        self.status = character.status
        self.species = character.species
        self.imageURL = character.imageURL
    }
}
