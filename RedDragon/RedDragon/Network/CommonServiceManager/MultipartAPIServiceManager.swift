//
//  MultipartAPIServiceManager.swift
//  RedDragon
//
//  Created by Qasr01 on 29/11/2023.
//

import Foundation

class MultipartAPIServiceManager<ResponseModel: Decodable>: ObservableObject {
    
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
    
    // Create a URL request with optional authorization token for different types of users.
    private func makeURLRequest(urlString: String,
                                params: [String: Any]?, isGuestUser: Bool, anyDefaultToken: String, imageName: String, imageData: Data, imageKey: String) -> URLRequest? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyData = Data()
        let lineBreak = "\r\n"
        
        if let parameters = params {
            for (key, value) in parameters {
                bodyData.append("--\(boundary + lineBreak)")
                bodyData.append("Content-Disposition: form-data; name=\" \(key)\"\(lineBreak + lineBreak)")
                bodyData.append("\(value as AnyObject)\(lineBreak)")
            }
        }
        
        if imageKey != "" {
            bodyData.append("--\(boundary + lineBreak)")
            bodyData.append("Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(imageName)\"\(lineBreak)")
            bodyData.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)")
            bodyData.append(imageData)
            bodyData.append(lineBreak)
            bodyData.append("--\(boundary)--\(lineBreak)")
        }
        
        request.httpBody = bodyData
        
        if isGuestUser {
            let guestUserToken = anyDefaultToken.isEmpty ? DefaultToken.guestPredictionUser : anyDefaultToken
            request.setValue("Bearer " + guestUserToken, forHTTPHeaderField: "Authorization")
        } else {
            if let userToken = UserDefaults.standard.token, userToken != ""  {
                request.setValue("Bearer " + userToken, forHTTPHeaderField: "Authorization")
            }
        }
        print("[Request] :==>\(request)\n[Token] :==>\(UserDefaults.standard.token ?? "")\n[Parameter] :==>\(params ?? [:])")
        return request
    }
    
    // Asynchronously fetch and execute a network request.
    private func fetchExecuteFunction(urlString: String,
                                      params: [String: Any]?, isGuestUser: Bool, anyDefaultToken: String, imageName: String, imageData: Data, imageKey: String) async throws -> ResponseModel {
        guard let urlRequest = makeURLRequest(urlString: urlString, params: params, isGuestUser: isGuestUser, anyDefaultToken: anyDefaultToken, imageName: imageName, imageData: imageData, imageKey: imageKey) else {
            throw CustomErrors.invalidRequest
        }
        return try await network.executeAsync(with: urlRequest)
    }
    
    // Asynchronously perform an API call with optional parameters.
    func asyncCall(urlString: String, params: [String: Any]?, isGuestUser: Bool = false, anyDefaultToken: String = "", imageName: String = "", imageData: Data = Data(), imageKey: String = "") {
        
        guard Reachability.isConnectedToNetwork() else {
            showError?(ErrorMessage.networkAlert.localized)
            return
        }
        Task { @MainActor in
            displayLoader?(true)
            do {
                let response = try await fetchExecuteFunction(urlString: urlString, params: params, isGuestUser: isGuestUser, anyDefaultToken: anyDefaultToken, imageName: imageName, imageData: imageData, imageKey: imageKey)
                responseData = response
                // print(responseData as Any)
            } catch {
                showError?(error.localizedDescription)
            }
            displayLoader?(false)
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
