//
//  CartoonCharactersWorker.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersWorking {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void)
}

final class CartoonCharactersWorker {
    private let network: NetworkServicing

    init(network: NetworkServicing = NetworkService()) {
        self.network = network
    }
}

// MARK: - CartoonCharactersWorking
extension CartoonCharactersWorker: CartoonCharactersWorking {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void) {
        let endpoint = RickAndMortyEndpoint.characters(page: page)
        network.request(endpoint, completion: completion)
    }
}
