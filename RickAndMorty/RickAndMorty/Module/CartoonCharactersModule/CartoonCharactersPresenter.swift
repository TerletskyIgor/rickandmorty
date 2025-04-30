//
//  CartoonCharactersPresenter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersPresentationLogic {
    func presentCharacters(response: CartoonCharacters.Fetch.Response)
}

final class CartoonCharactersPresenter {
    weak var viewController: CartoonCharactersDisplayLogic?
}

// MARK: - CartoonCharactersPresentationLogic
extension CartoonCharactersPresenter: CartoonCharactersPresentationLogic {
    func presentCharacters(response: CartoonCharacters.Fetch.Response) {
        let characters = response.characters.map {
            CartoonCharacters.Fetch.ViewModel.DisplayCharacter(name: $0.name,
                                                               imageURL: URL(string: $0.image) )
        }
        let viewModel = CartoonCharacters.Fetch.ViewModel(characters: characters)
        viewController?.displayCharacters(viewModel: viewModel)
    }
}
