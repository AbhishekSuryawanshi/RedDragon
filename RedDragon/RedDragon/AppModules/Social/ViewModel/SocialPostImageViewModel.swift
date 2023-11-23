//
//  SocialPostImageViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 21/11/2023.
//

import Foundation

class SocialPostImageViewModel: ObservableObject {
    static let shared = SocialPostImageViewModel()
    
    @Published private(set) var userImage: String?
    let session: URLSession
    
    init(userImage: String? = nil,
         session: URLSession = URLSession.shared) {
        self.userImage = userImage
        self.session = session
    }
    
    var showError: ((String) -> ())?
    var displayLoader: ((Bool) -> ())?
    
    ///upload image in multipart form
    private func createURLRequest(imageName: String, imageData: Data) -> URLRequest? {
        guard let url = URL(string: URLConstants.postImage) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyData = Data()
        
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"img\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        bodyData.append(imageData)
        bodyData.append("\r\n".data(using: .utf8)!)
        
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = bodyData
       
        if let userToken = UserDefaults.standard.token, userToken != ""  {
            request.setValue("Bearer " + userToken, forHTTPHeaderField: "Authorization")
        }
        print("[Request] :==>\(URLConstants.postImage)\n[Token] :==>\(UserDefaults.standard.token ?? "")")
        
        return request
    }
    
    private func fetchUploadedImageURL(imageName: String, imageData: Data) async throws -> String {
        guard let urlRequest = createURLRequest(imageName: imageName, imageData: imageData) else {
            throw CustomErrors.invalidJSON
        }
        do {
            let responseString = try await executeAsync(with: urlRequest)
            return responseString
        } catch {
            return "Error: \(error)"
        }
    }
    ///call this function to upload image in multipart form
    ///image url added to @Published variable userImage
    func imageAsyncCall(imageName: String, imageData: Data) {
        Task { @MainActor in
            displayLoader?(true)
            do {
                let responseData = try await self.fetchUploadedImageURL(imageName: imageName, imageData: imageData)
                                
                if responseData != "" {
                    let jsonData = Data(responseData.utf8)
                    let _response = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    let responseDictionary = _response as? [String: Any]
                    print("[Response] :==> \(responseDictionary ?? [:])")
                    let decoder = JSONDecoder()
                    do {
                        let imageResponse = try decoder.decode(SocialPostImageResponse.self, from: jsonData)
                        if let dataResponse = imageResponse.response {
                            userImage = URLConstants.euro5leagueBaseURL + (dataResponse.data?.imageUrl ?? "")
                        } else {
                            if let errorResponse = imageResponse.error {
                                showError?(errorResponse.messages?.first ?? CustomErrors.unknown.description)
                            }
                        }
                    } catch {
                        showError?(CustomErrors.invalidJSON.description)
                    }
                }
            } catch {
                showError?(error.localizedDescription)
            }
            displayLoader?(false)
        }
    }
    
    ///saperate https header function: reason:- response is only string, not key value pair [key: value]
    private func executeAsync(with request: URLRequest) async throws -> String {
        let (data, urlResponse) = try await session.data(for: request)
        guard let httpsResponse = urlResponse as? HTTPURLResponse else {
            throw CustomErrors.unknown
        }
        
        let statusCode = httpsResponse.statusCode
        if 200..<400 ~= statusCode {
            // Convert the raw data to a string
            if let responseString = String(data: data, encoding: .utf8) {
                return responseString
            } else {
                throw CustomErrors.general(message: "Failed to decode response data.")
            }
        } else {
            // let statusCodeMessage = showStatusCodeMeaning(for: statusCode)
            // throw CustomErrors.general(message: statusCodeMessage)
           throw CustomErrors.noData
        }
    }
}

