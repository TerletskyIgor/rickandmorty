//
//  CharacterDetailInteractor.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CharacterDetailBusinessLogic {
    func loadCharacter(request: CharacterDetail.Request)
}

class CharacterDetailInteractor: CharacterDetailBusinessLogic {
    var presenter: CharacterDetailPresentationLogic?
    var character: Character!

    func loadCharacter(request: CharacterDetail.Request) {
        let response = CharacterDetail.Response(character: character)
        presenter?.presentCharacter(response: response)
    }
}
