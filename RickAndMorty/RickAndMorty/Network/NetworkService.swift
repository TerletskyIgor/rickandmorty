//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

protocol NetworkServicing {
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class NetworkService: NetworkServicing {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = endpoint.urlRequest else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(NetworkError.noData))
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

