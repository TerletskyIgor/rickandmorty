//
//  CartoonCharactersModels.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

enum CartoonCharacters {
    enum Fetch {
        struct Request { }

        struct Response {
            let characters: [Character]
        }

        struct ViewModel {
            struct DisplayCharacter {
                let name: String
                let imageURL: URL?
            }

            let characters: [DisplayCharacter]
        }
    }
}

