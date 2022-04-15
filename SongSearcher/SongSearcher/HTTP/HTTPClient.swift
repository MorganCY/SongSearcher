//
//  HTTPClient.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

import Foundation

protocol HTTPClienting {
    func requestData<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

final class HTTPClient: HTTPClienting {

    func requestData<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                completion(.success(responseData))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
