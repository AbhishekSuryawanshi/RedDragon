//
//  ImageViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 03/11/2023.
//

import Foundation

class PostImageViewModel: ObservableObject {
    static let shared = PostImageViewModel()
    
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
    
    func imageAsyncCall(imageName: String, imageData: Data) {
        Task { @MainActor in
            displayLoader?(true)
            do {
                let responseData = try await fetchUploadedImageURL(imageName: imageName, imageData: imageData)
                var imageModel = ImageResponse()
                if responseData != "" {
                    let jsonData = Data(responseData.utf8)//matchDetail.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    do {
                        imageModel = try decoder.decode(ImageResponse.self, from: jsonData)
                        userImage = URLConstants.socialBaseURL + (imageModel.postImage ?? "")
                    } catch {
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
            //            if let responseString = String(data: data, encoding: .utf8) {
            //                //print("Raw Response Data: \(responseString)")
            //            }
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

