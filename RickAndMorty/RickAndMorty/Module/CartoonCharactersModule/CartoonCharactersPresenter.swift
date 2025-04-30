//
//  CartoonCharactersPresenter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersPresentationLogic: AnyObject {
    func presentCharacters(response: CartoonCharacters.Fetch.Response)
}

final class CartoonCharactersPresenter: CartoonCharactersPresentationLogic {
    weak var viewController: CartoonCharactersDisplayLogic?

    func presentCharacters(response: CartoonCharacters.Fetch.Response) {
        let items = response.response.results.map { char in
            CartoonCharacters.Fetch.ViewModel.DisplayCharacter(
                id: char.id,
                name: char.name,
                species: char.species,
                imageURL: URL(string: char.image)
            )
        }
        let viewModel = CartoonCharacters.Fetch.ViewModel(characters: items)
        viewController?.displayCharacters(viewModel: viewModel)
    }
}
