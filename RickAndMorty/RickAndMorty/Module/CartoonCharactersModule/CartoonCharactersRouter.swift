//
//  CartoonCharactersRouter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersRoutingLogic: AnyObject {
    func routeToDetail(for character: CartoonCharacters.Fetch.ViewModel.DisplayCharacter)
}

final class CartoonCharactersRouter: CartoonCharactersRoutingLogic {
    weak var viewController: CartoonCharactersViewController?

    func routeToDetail(for character: CartoonCharacters.Fetch.ViewModel.DisplayCharacter) {
        // let detailVC = CharacterDetailViewController(character: character)
        // viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
