//
//  NetworkManager.swift
//  RedDragon
//
//  Created by Abdullah on 23/12/2023.
//

import Alamofire

public struct NetworkManager {
    
    static func loadData<T: Encodable, U: Decodable>(
        request: NetworkRequest,
        parameters: T?,
        completion: @escaping (
            Result<U, CustomError>
        ) -> Void
    ) {
        if Reachability.isConnectedToNetwork() {
            AF.request(
                request.url,
                method: request.httpMethod,
                parameters: parameters,
                encoder: request.encoding
            )
            .validate(statusCode: 200...299)
            .responseDecodable(of: U.self) { response in
                
                switch response.result {
                case .success(_):
                    completion(.success(response.value!))
                case .failure(let error):
                    completion(.failure(.general(message: error.localizedDescription)))
                }
            }
        } else {
            completion(.failure(.noNetwork))
            return
        }
    }
    
}

enum CustomError: Error {
    case unknown
    case noData
    case noNetwork
    case general(message: String)
    
    var description: String {
        switch self {
        case .noNetwork:
            return "No internet. Please try again later".localized
        case .unknown:
            return "Some unknown error has occured".localized
        case .noData:
            return "No data available".localized
        case .general(let message):
            return message
        }
    }
}
