//
//  CharacterDetailPresenter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CharacterDetailPresentationLogic {
    func presentCharacter(response: CharacterDetail.Response)
}

class CharacterDetailPresenter {
    weak var viewController: CharacterDetailDisplayLogic?
}

// MARK: - CharacterDetailPresentationLogic
extension CharacterDetailPresenter: CharacterDetailPresentationLogic {
    func presentCharacter(response: CharacterDetail.Response) {
        let vm = CharacterDetail.ViewModel(
            name: response.character.name,
            imageURL: response.character.image
        )
        viewController?.displayCharacter(viewModel: vm)
    }
}
