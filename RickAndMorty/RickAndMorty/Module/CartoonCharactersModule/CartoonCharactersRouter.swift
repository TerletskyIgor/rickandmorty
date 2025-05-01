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
        let character = Character(id: character.id,
                                  name: character.name,
                                  status: character.species,
                                  species: character.species,
                                  image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        let detailVC = CharacterDetailConfigurator.configure(character: character)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
