//
//  HTTPSClient.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

protocol HTTPSClientProtocol {
    func executeAsync<T: Decodable>(with request: URLRequest) async throws -> T
}

class HTTPSClient: HTTPSClientProtocol {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    ///
    func executeAsync<T: Decodable>(with request: URLRequest) async throws -> T {
        let (data, urlResponse) = try await session.data(for: request)
        guard let res = urlResponse as? HTTPURLResponse, 200..<400 ~= res.statusCode else {
            throw CustomErrors.unknown
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
