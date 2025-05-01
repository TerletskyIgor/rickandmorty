//
//  CartoonCharactersPresenter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersPresentationLogic: AnyObject {
    func presentCharacters(character: [Character])
    func showError(title: String, message: String)
}

final class CartoonCharactersPresenter: CartoonCharactersPresentationLogic {
    weak var viewController: CartoonCharactersDisplayLogic?

    func presentCharacters(character: [Character]) {
        viewController?.displayCharacters(character: character)
    }
    
    func showError(title: String, message: String) {
        viewController?.showError(title: title, message: message)
    }
}
