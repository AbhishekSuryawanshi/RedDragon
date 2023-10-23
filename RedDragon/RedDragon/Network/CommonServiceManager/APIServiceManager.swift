//
//  APIServiceManager.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

class APIServiceManager<ResponseModel: Decodable>: ObservableObject {
    
    @Published private(set) var responseData: ResponseModel?
    let network: HTTPSClientProtocol
    
    init(responseData: ResponseModel? = nil, network: HTTPSClientProtocol = HTTPSClient()) {
        self.responseData = responseData
        self.network = network
    }
    
    var showError: ((String) -> ())?
    var displayLoader: ((Bool) -> ())?
    
//    private func makeURLRequest(urlString: String, method: RequestType, parameters: [String: Any]?, includeAuthToken: Bool = true) -> URLRequest? {
//        guard let url = URL(string: urlString) else { return nil }
//        
//        var authToken = UserDefaults.standard.string(forKey: UserDefaultString.token) ?? ""
//        
//        let guest = UserDefaults.standard.bool(forKey: UserDefaultString.guestUser)
//        if guest {
//            authToken = DefaultToken.guestUser
//        }
//        
//        let authorizationToken = HTTPHeader.createAuthorizationHeader(token: authToken)
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        do {
//            if parameters != nil {
//                if let param = parameters {
//                    request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
//                }
//            }
//            
//            let allHeaders = HTTPHeader.commonHeaders.merging(authorizationToken, uniquingKeysWith: { $1 })
//            for (key, value) in allHeaders {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//            return request
//        } catch {
//            return nil
//        }
//    }
    
    private func makeURLRequest(urlString: String, method: RequestType, parameters: [String: Any]?, includeAuthToken: Bool = true) -> URLRequest? {
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        do {
            if parameters != nil {
                if let param = parameters {
                    request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
                }
            }

            if includeAuthToken {
                // Include the authorization token
                if let authToken = UserDefaults.standard.string(forKey: UserDefaultString.token), !authToken.isEmpty {
                    let authorizationToken = HTTPHeader.createAuthorizationHeader(token: authToken)
                    let allHeaders = HTTPHeader.commonHeaders.merging(authorizationToken, uniquingKeysWith: { $1 })
                    for (key, value) in allHeaders {
                        request.setValue(value, forHTTPHeaderField: key)
                    }
                }
            } else {
                // Set other common headers without the authorization header.
                let allHeaders = HTTPHeader.commonHeaders
                for (key, value) in allHeaders {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }

            return request
        } catch {
            return nil
        }
    }
    
    private func fetchExecuteFunction(urlString: String, method: RequestType, parameters: [String: Any]?) async throws -> ResponseModel {
        guard let urlRequest = makeURLRequest(urlString: urlString, method: method, parameters: parameters) else {
            throw CustomErrors.invalidRequest
        }
        return try await network.executeAsync(with: urlRequest)
    }
    
    func asyncCall(urlString: String, method: RequestType, parameters: [String: Any]?) {
        Task { @MainActor in
            displayLoader?(true)
            do {
                let response = try await fetchExecuteFunction(urlString: urlString, method: method, parameters: parameters)
                responseData = response
               // print(responseData as Any)
            } catch {
                showError?(error.localizedDescription)
            }
            displayLoader?(false)
        }
    }
}
