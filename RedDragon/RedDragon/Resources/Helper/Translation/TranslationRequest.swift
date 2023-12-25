//
//  TranslationRequest.swift
//  RedDragon
//
//  Created by Abdullah on 23/12/2023.
//

import Alamofire

struct TranslationRequest: Encodable {
    
}

extension TranslationRequest: NetworkRequest {
    var httpMethod: Alamofire.HTTPMethod {
        .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        .default
    }
    
    var url: String {
        URLConstants.translationBaseURL + URLConstants.translation
    }
    
    var encoding: Alamofire.ParameterEncoder {
        URLEncodedFormParameterEncoder.default
    }
}
