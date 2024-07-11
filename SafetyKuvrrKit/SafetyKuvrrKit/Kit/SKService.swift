//
//  SKService.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 27/06/24.
//

import Foundation
import Alamofire

struct SKService {
    private static let baseURL = "https://safety-red5.kuvrr.com/api/v1/"
    
    static func apiCall<T: Decodable>(with urlString: String, method: HTTPMethod = .get, parameters: Parameters? = nil, responseModel: T.Type = SKMessage.self, success: @escaping((T?)-> Void), failure: @escaping((String?)-> Void)) {
        let headers: HTTPHeaders = [
            "X-CSRFToken": SKUserDefaults.csrfToken ?? "",
            "Accept": "application/json",
            "Referer": SKService.baseURL
        ]
        AF.sessionConfiguration.timeoutIntervalForRequest = 20
        AF.sessionConfiguration.headers = headers
        print("\n======================================================================")
        print("API Name : \"\(urlString)\"")
        print("Method : \(method.rawValue)")
        print("-------------------------------")
        if let params = parameters {
            print("Request: \(params)")
            print("-------------------------------")
        }
        //
        let authRequest = AF.request(
            SKService.baseURL + urlString,
            method: method,
            parameters: parameters,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
        //
        authRequest.responseDecodable(of: responseModel) { response in
            if let fields = response.response?.allHeaderFields as? [String : String], let requestURL = response.request?.url {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: requestURL)
                HTTPCookieStorage.shared.setCookies(cookies, for: requestURL, mainDocumentURL: nil)
            }
            //
            let responseCode = "\(response.response?.statusCode.description ?? "")"
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response - (Code-\(responseCode)): \(utf8Text)")
            } else {
                print("Response - (Code-\(responseCode)): Empty")
                if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode < 300 {
                    success(SKMessage(message: "Empty Response") as? T)
                    return
                }
            }
            //
            switch response.result {
            case .success(let value):
                if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode < 300 {
                    if let data = response.data, let errorMessage = SKService.getErrorResponse(forData: data) {
                        failure(errorMessage)
                    } else {
                        success(value)
                    }
                } else {
                    if let data = response.data, let errorMessage = SKService.getErrorResponse(forData: data) {
                        failure(errorMessage)
                    } else {
                        failure("Something went wrong!")
                    }
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    private static func getErrorResponse(forData data: Data) -> String? {
        do {
            let errorModel = try JSONDecoder().decode(SKErrorMessage.self, from: data)
            return(errorModel.errorMessage?.first)
        } catch {
            return(error.localizedDescription)
        }
    }
}
