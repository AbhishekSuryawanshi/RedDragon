//
//  NetworkRequest.swift
//  RedDragon
//
//  Created by Abdullah on 23/12/2023.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: String { get }
    var encoding: ParameterEncoder { get }
}
