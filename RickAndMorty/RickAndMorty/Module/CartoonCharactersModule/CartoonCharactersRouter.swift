//
//  CartoonCharactersRouter.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersRoutingLogic: AnyObject {
    func routeToDetail(for character: Character)
}

final class CartoonCharactersRouter: CartoonCharactersRoutingLogic {
    weak var viewController: CartoonCharactersViewController?

    func routeToDetail(for character: Character) {
        let detailVC = CharacterDetailConfigurator.configure(character: character)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
