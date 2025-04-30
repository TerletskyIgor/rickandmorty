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

final class CartoonCharactersWorker: CartoonCharactersWorking {
    private let network: NetworkServicing

    init(network: NetworkServicing = NetworkService()) {
        self.network = network
    }

    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void) {
        let endpoint = RickAndMortyEndpoint.characters(page: page)
        network.request(endpoint, completion: completion)
    }
}
