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
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkService: NetworkServicing {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let request = endpoint.urlRequest else {
            completion(.failure(.invalidURL)); return
        }
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(.requestFailed(error)))
            }
            guard let http = response as? HTTPURLResponse,
                  200..<300 ~= http.statusCode else {
                return completion(.failure(.badStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)))
            }
            guard let data = data else {
                return completion(.failure(.noData))
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}
