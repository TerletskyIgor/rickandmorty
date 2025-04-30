//
//  CartoonCharactersInteractor.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol CartoonCharactersBusinessLogic {
    func fetchCharacters(request: CartoonCharacters.Fetch.Request)
    func loadCharacters(page: Int, completion: @escaping (Bool) -> Void)
}

final class CartoonCharactersInteractor {
    var presenter: CartoonCharactersPresentationLogic?
    var networkService: NetworkServicing = NetworkService()
}

// MARK: - CartoonCharactersBusinessLogic
extension CartoonCharactersInteractor: CartoonCharactersBusinessLogic {
    func fetchCharacters(request: CartoonCharacters.Fetch.Request) {
        let endpoint = RickAndMortyEndpoint.characters()

        networkService.request(endpoint) { [weak self] (result: Result<CharacterResponse, Error>) in
            switch result {
            case .success(let response):
                let response = CartoonCharacters.Fetch.Response(characters: response.results)
                DispatchQueue.main.async {
                    self?.presenter?.presentCharacters(response: response)
                }
            case .failure(let error):
                // TODO: - Show Error
                print("Error fetching characters: \(error)")
            }
        }
    }
    
    func loadCharacters(page: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = RickAndMortyEndpoint.characters(page: page)
        networkService.request(endpoint) { [weak self] (result: Result<CharacterResponse, Error>) in
            switch result {
            case .success(let response):
                var hasMore = false
                if let _ = response.info.next {
                    hasMore = true
                }
                
                let response = CartoonCharacters.Fetch.Response(characters: response.results)
                
                DispatchQueue.main.async {
                    self?.presenter?.presentCharacters(response: response)
                }
                
                completion(hasMore)
                
            case .failure(let error):
                print("Error fetching characters: \(error)")
                // TODO: - Show Error
            }
        }
    }
}
