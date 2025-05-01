//
//  CharacterDetailConfigurator.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

class CharacterDetailConfigurator {
    static func configure(character: Character) -> CharacterDetailViewController {
        let viewController = CharacterDetailViewController()
        let interactor = CharacterDetailInteractor()
        let presenter = CharacterDetailPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.character = character
        
        return viewController
    }
}
