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

final class CartoonCharactersInteractor {
    var presenter: CartoonCharactersPresentationLogic?
    var worker: CartoonCharactersWorking = CartoonCharactersWorker()
}

// MARK: - CartoonCharactersBusinessLogic
extension CartoonCharactersInteractor: CartoonCharactersBusinessLogic {
    func fetchCharacters(page: Int, callback: @escaping (Bool) -> Void) {
        worker.fetchCharacters(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.presenter?.presentCharacters(character: data.results)
                let hasMoreCharacters = data.info.next != nil
                callback(hasMoreCharacters)
            case .failure(let error):
                self.presenter?.showError(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
