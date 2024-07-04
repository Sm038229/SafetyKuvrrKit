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
    
    static func apiCall<T: Decodable>(with urlString: String, method: HTTPMethod = .get, parameters: Parameters? = nil, responseModel: T.Type, success: @escaping((T?)-> Void), failure: @escaping((String?)-> Void)) {
        let headers: HTTPHeaders = [
            "X-CSRFToken": SKUserDefaults.csrfToken ?? "",
            "Accept": "application/json",
            "Referer": SKService.baseURL
        ]
        AF.sessionConfiguration.timeoutIntervalForRequest = 20
        AF.sessionConfiguration.headers = headers
        print("API : \(urlString)  ======================================================================")
        print("Request: \(String(describing: parameters))")
        AF.request(SKService.baseURL + urlString, method: method, parameters: parameters, headers: headers).responseDecodable(of: responseModel) { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            switch response.result {
            case .success(let value):
                print(value)
                success(response.value)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
}
