//
//  CharacterDetailPresenter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CharacterDetailPresentationLogic {
    func presentCharacter(character: Character)
}

class CharacterDetailPresenter {
    weak var viewController: CharacterDetailDisplayLogic?
}

// MARK: - CharacterDetailPresentationLogic
extension CharacterDetailPresenter: CharacterDetailPresentationLogic {
    func presentCharacter(character: Character) {
        viewController?.displayCharacter(character: character)
    }
}
