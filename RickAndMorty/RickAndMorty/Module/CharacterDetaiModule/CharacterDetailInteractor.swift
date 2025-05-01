//
//  CharacterDetailInteractor.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CharacterDetailBusinessLogic {
    func loadCharacter()
}

class CharacterDetailInteractor {
    var presenter: CharacterDetailPresentationLogic?
    var character: Character!
}

// MARK: - CharacterDetailBusinessLogic
extension CharacterDetailInteractor: CharacterDetailBusinessLogic {
    func loadCharacter() {
        presenter?.presentCharacter(character: character)
    }
}
