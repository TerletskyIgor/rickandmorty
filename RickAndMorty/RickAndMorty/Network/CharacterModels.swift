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

enum CharacterStatus: String, Decodable {
    case alive
    case dead
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let statusString = try container.decode(String.self)
        
        switch statusString.lowercased() {
        case "alive":
            self = .alive
        case "dead":
            self = .dead
        default:
            self = .unknown
        }
    }
}

struct Character: Decodable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
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
        let status = CharacterStatus(rawValue: cdCharacter.status ?? "dead") ?? .unknown
        self.init(id: Int(cdCharacter.id),
                  name: cdCharacter.name ?? "Unknown",
                  status: status,
                  species: cdCharacter.species ?? "Unknown",
                  imageURL: cdCharacter.imageURL ?? "Unknown"
        )
    }
}

extension CDCharacter {
    func update(from character: Character) {
        self.id = Int32(character.id)
        self.name = character.name 
        self.status = character.status.rawValue
        self.species = character.species
        self.imageURL = character.imageURL
    }
}
