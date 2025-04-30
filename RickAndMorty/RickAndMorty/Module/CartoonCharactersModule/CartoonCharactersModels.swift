//
//  CartoonCharactersModels.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

enum CartoonCharacters {
    enum Fetch {
        struct Request {}
        struct Response {
            let response: CharacterResponse
        }
        struct ViewModel {
            struct DisplayCharacter: Hashable {
                let id: Int
                let name: String
                let species: String
                let imageURL: URL?
            }
            let characters: [DisplayCharacter]
        }
    }
}

