//
//  CharacterDetailModels.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

enum CharacterDetail {
    struct Request {}
    
    struct Response {
        let character: Character
    }
    
    struct ViewModel {
        let name: String
        let imageURL: String
    }
}
