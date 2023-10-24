//
//  HTTPSClient.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

// A protocol defining the interface for an HTTPS client that can execute asynchronous requests and decode responses.
protocol HTTPSClientProtocol {
    func executeAsync<T: Decodable>(with request: URLRequest) async throws -> T
}

// A concrete implementation of the HTTPS client using URLSession.
class HTTPSClient: HTTPSClientProtocol {
    let session: URLSession
    
    // Initialize the HTTPS client with an optional custom URLSession or use the shared session by default.
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // Execute an asynchronous network request with the provided URLRequest and decode the response.
    func executeAsync<T: Decodable>(with request: URLRequest) async throws -> T {
        // Perform the network request and retrieve data and response.
        let (data, urlResponse) = try await session.data(for: request)
        // Check if the HTTP response status code is within the success range (200-399).
        guard let res = urlResponse as? HTTPURLResponse, 200..<400 ~= res.statusCode else {
            throw CustomErrors.unknown
        }
        // Decode the received data into the specified Decodable type.
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
