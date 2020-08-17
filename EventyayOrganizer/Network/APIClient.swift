//
//  APIClient.swift
//  EventyayOrganizer
//
//  Created by Dilum De Silva on 3/29/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import Foundation
import ObjectMapper

class APIClient {
    var kBaseURL = ControllerConstants.CommonURL.Debug.baseURL
    static let shared = APIClient() // /users/checkEmail

    typealias APIResponseCallback<T> = (_ response: HTTPURLResponse?, _ data: T?, _ error: Error?) -> Void

    private init() {}

    // http get method api calls should use this function
    func get<T: Mappable>(_ endPoint: String,
                          mappingClass: T.Type,
                          completion: @escaping APIResponseCallback<T>) {
        guard let url = URL(string: "\(kBaseURL)\(endPoint)") else {
            print(ControllerConstants.Errors.APIRequestErrors.URLConcatenation)
            return
        }

        AF.request(url).responseObject { (response: AFDataResponse<T>) in
            if response.error != nil {
                completion(response.response, nil, response.error)
            } else {
                completion(response.response, response.value, nil)
            }
        }
    }

    // http post method api calls should use this function
    func post<T: Mappable>(_ endPoint: String,
                           withParams params: [String: Any],
                           type: T,
                           completion: @escaping APIResponseCallback<T>) throws {
        guard let url = URL(string: "\(kBaseURL)\(endPoint)") else {
            print(ControllerConstants.Errors.APIRequestErrors.URLConcatenation)
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = data
            AF.request(urlRequest).responseObject { (response: AFDataResponse<T>) in
                if response.error != nil {
                    completion(response.response, nil, response.error)
                } else {
                    completion(response.response, response.value, nil)
                }
            }
        } catch {
            completion(nil, nil, APIClientError.jsonSerializationError)
        }
    }
}

enum APIClientError: Error {
    case jsonSerializationError
}
