//
//  SKService.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 27/06/24.
//

import Foundation
import Alamofire
import ProgressHUD

struct SKService {
    private static let baseURL = "https://safety-red5.kuvrr.com/api/v1/"
    private static let sessionCookie = "csrftoken"
    private static let sessionIDCookie = "sessionid"
    
    static func apiCall<T: Decodable>(with urlString: String, method: HTTPMethod = .get, parameters: Parameters? = nil, responseModel: T.Type = Empty.self, success: @escaping((T?)-> Void), failure: @escaping((String?)-> Void)) {
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
        var authRequest: DataRequest!
        if method == .get {
            authRequest = AF.request(
                SKService.baseURL + urlString,
                method: method,
                parameters: parameters,
                headers: headers
            )
        } else {
            ProgressHUD.animate()
            authRequest = AF.request(
                SKService.baseURL + urlString,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
        }
        
        authRequest.validate(statusCode: 200..<300)
        authRequest.validate(contentType: ["application/json"])
        //
        authRequest.responseDecodable(of: responseModel, emptyResponseCodes: [200, 204, 205]) { response in
            SKService.setupCookies()
            //
            let responseCode = "\(response.response?.statusCode.description ?? "")"
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response [\(urlString)] - (Code-\(responseCode)): \(utf8Text)")
            } else {
                print("Response [\(urlString)] - (Code-\(responseCode)): Empty")
            }
            //
            switch response.result {
            case .success(let value):
                ProgressHUD.remove()
                NSLog("Success: \(value)")
                success(value)
            case .failure(let error):
                if let data = response.data, let errorMessage = SKService.getErrorResponse(forData: data) {
                    ProgressHUD.failed(error)
                } else {
                    NSLog("Response Error: " + error.localizedDescription)
                    failure(error.localizedDescription)
                }
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
    
    private static func getResponse<T: Decodable>(forData data: Data, model: T.Type) -> T? {
        do {
            let model = try JSONDecoder().decode(model, from: data)
            return(model)
        } catch {
            print(error.localizedDescription)
            return nil
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
