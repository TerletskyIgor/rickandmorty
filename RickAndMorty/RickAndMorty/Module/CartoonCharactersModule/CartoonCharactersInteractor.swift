//
//  CartoonCharactersInteractor.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersBusinessLogic {
    func fetchCharacters(page: Int, callback: @escaping (Bool) -> Void)
}

final class CartoonCharactersInteractor: CartoonCharactersBusinessLogic {
    var presenter: CartoonCharactersPresentationLogic?
    var worker: CartoonCharactersWorking = CartoonCharactersWorker()

    func fetchCharacters(page: Int, callback: @escaping (Bool) -> Void) {
        worker.fetchCharacters(page: page) { [weak self] result in
            switch result {
            case .success(let data):
                let response = CartoonCharacters.Fetch.Response(response: data)
                self?.presenter?.presentCharacters(response: response)
                let hasMoreCharacters = response.response.info.next != nil
                callback(hasMoreCharacters)
            case .failure(let error):
                print(error)
            }
        }
    }
}
