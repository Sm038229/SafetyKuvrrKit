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
    static func apiCall<T: Decodable>(with urlString: String, method: HTTPMethod = .get, parameters: Parameters? = nil, responseModel: T.Type, success: @escaping((T?)-> Void), failure: @escaping((String?)-> Void)) {
        ProgressHUD.animate()
        let headers: HTTPHeaders = [
            //.authorization(bearerToken: ""),
            .accept("application/json")
        ]
        AF.request(urlString, method: method, parameters: parameters, headers: headers).responseDecodable(of: responseModel) { response in
            if let json = response.value {
                print("Response: \(String(describing: json))") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            switch response.result {
            case .success(let count):
                print(count)
                ProgressHUD.success()
                success(response.value)
            case .failure(let error):
                ProgressHUD.failed()
                failure(error.localizedDescription)
            }
        }
    }
}
