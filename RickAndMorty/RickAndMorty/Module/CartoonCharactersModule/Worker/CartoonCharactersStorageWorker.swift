//
//  CartoonCharactersStorageWorker.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 01.05.2025.
//

import Foundation

protocol CartoonCharactersStorageWorkering {
    func save(characters: [Character])
    func fetchStoredCharacters() -> [Character]
    func clearAllCharacters()
}

final class CartoonCharactersStorageWorker {
    private let coreDataManager = CoreDataManager.shared
}

//MARK: - CartoonCharactersStorageWorkering
extension CartoonCharactersStorageWorker: CartoonCharactersStorageWorkering {
    func save(characters: [Character]) {
        coreDataManager.saveCharacters(characters)
    }

    func fetchStoredCharacters() -> [Character] {
        return coreDataManager.fetchCharacters()
    }

    func clearAllCharacters() {
        coreDataManager.deleteAllCharacters()
    }
}
