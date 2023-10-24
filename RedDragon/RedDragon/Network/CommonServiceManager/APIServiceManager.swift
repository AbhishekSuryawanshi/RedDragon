//
//  APIServiceManager.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

class APIServiceManager<ResponseModel: Decodable>: ObservableObject {
    
    // The response data received from the API call.
    @Published private(set) var responseData: ResponseModel?
    let network: HTTPSClientProtocol
    
    // Initialize the API service manager with optional initial response data and a network client.
    init(responseData: ResponseModel? = nil, 
         network: HTTPSClientProtocol = HTTPSClient()) {
        self.responseData = responseData
        self.network = network
    }
    
    // Closure to handle and show error messages.
    var showError: ((String) -> ())?
    // Closure to manage the display of loading indicators.
    var displayLoader: ((Bool) -> ())?
    
    /// Create a URL request with optional authorization token for different types of users.
    private func makeURLRequest(urlString: String, 
                                method: RequestType,
                                parameters: [String: Any]?,
                                isGuestUser: Bool) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        do {
            if parameters != nil {
                if let param = parameters {
                    request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
                }
            }
            var allHeaders = HTTPHeader.commonHeaders

            if isGuestUser {
                let guestUserToken = DefaultToken.guestUser
                let authorizationToken = HTTPHeader.createAuthorizationHeader(token: guestUserToken)
                allHeaders = allHeaders.merging(authorizationToken, uniquingKeysWith: { $1 })
            } else {
                if let userToken = UserDefaults.standard.string(forKey: UserDefaultString.token) {
                    let authorizationToken = HTTPHeader.createAuthorizationHeader(token: userToken)
                    allHeaders = allHeaders.merging(authorizationToken, uniquingKeysWith: { $1 })
                }
            }
            for (key, value) in allHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        } catch {
            return nil
        }
    }
    
    // Asynchronously fetch and execute a network request.
    private func fetchExecuteFunction(urlString: String, 
                                      method: RequestType,
                                      parameters: [String: Any]?,
                                      isGuestUser: Bool) async throws -> ResponseModel {
        guard let urlRequest = makeURLRequest(urlString: urlString, method: method, parameters: parameters, isGuestUser: isGuestUser) else {
            throw CustomErrors.invalidRequest
        }
        return try await network.executeAsync(with: urlRequest)
    }
    
    ///For __Guest user__ :- asyncCall(urlString: "your_url", method: .get, parameters: nil, isGuestUser: true)
    ///_For __Regular user__ :- asyncCall(urlString: "your_url", method: .get, parameters: nil, isGuestUser: false)
    ///_For __no auth toke__ :- asyncCall(urlString: "your_url", method: .get, parameters: nil)
    
    ///In below function __urlString: String = URLConstants.baseURL + extension
    ///method: GET/POST/PUT/DELETE = RequestType.get
    ///parameter: [String: Any] = nil or ["key": "value"]
    
    // Asynchronously perform an API call with optional parameters.
    func asyncCall(urlString: String, 
                   method: RequestType,
                   parameters: [String: Any]?,
                   isGuestUser: Bool = false) {
        Task { @MainActor in
            displayLoader?(true)
            do {
                let response = try await fetchExecuteFunction(urlString: urlString, method: method, parameters: parameters, isGuestUser: isGuestUser)
                responseData = response
               // print(responseData as Any)
            } catch {
                showError?(error.localizedDescription)
            }
            displayLoader?(false)
        }
    }
}
