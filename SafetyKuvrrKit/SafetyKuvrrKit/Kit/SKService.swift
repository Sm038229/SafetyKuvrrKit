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
    private static let sessionCookie = "csrftoken"
    private static let sessionIDCookie = "sessionid"
    
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
            SKService.setupCookies()
            //
            let responseCode = "\(response.response?.statusCode.description ?? "")"
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response - (Code-\(responseCode)): \(utf8Text.htmlToUtf8())")
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
                if let data = response.data, let errorMessage = SKService.getErrorResponse(forData: data) {
                    NSLog("Error: " + errorMessage)
                    failure(errorMessage)
                } else {
                    if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode < 300 {
                        NSLog("Success: \(value)")
                        success(value)
                    } else {
                        NSLog("Something went wrong!")
                        failure("Something went wrong!")
                    }
                }
            case .failure(let error):
                NSLog(error.localizedDescription)
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
    
    private static func setupCookies() {
        if let url = URL(string: SKService.baseURL), let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                //print("\(cookie.name): \(cookie.value)")
                if cookie.name == sessionCookie {
                    let csrfToken = cookie.value
                    SKUserDefaults.csrfToken = csrfToken
                    AF.sessionConfiguration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
                }
            }
        }
    }
}
