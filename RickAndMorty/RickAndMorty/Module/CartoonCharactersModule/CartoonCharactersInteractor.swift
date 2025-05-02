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
    private var worker: CartoonCharactersWorking = CartoonCharactersWorker()
    private let storageWorker: CartoonCharactersStorageWorkering = CartoonCharactersStorageWorker()
}

// MARK: - CartoonCharactersBusinessLogic
extension CartoonCharactersInteractor: CartoonCharactersBusinessLogic {
    func fetchCharacters(page: Int, callback: @escaping (Bool) -> Void) {
        worker.fetchCharacters(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.presenter?.presentCharacters(character: data.results)
                self.storageWorker.save(characters: data.results)
                let hasMoreCharacters = data.info.next != nil
                callback(hasMoreCharacters)
            case .failure:
                let cachedCharacters = self.storageWorker.fetchStoredCharacters()

                if cachedCharacters.isEmpty {
                    self.presenter?.showError(title: "Error", message: NetworkError.noData.localizedDescription)
                } else {
                    self.presenter?.presentCharacters(character: cachedCharacters)
                }
                
                callback(false)
            }
        }
    }
}
