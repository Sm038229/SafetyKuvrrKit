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
    static func apiCall() {
        ProgressHUD.animate()
        AF.request("https://jsonplaceholder.typicode.com/todos/1").responseData { response in

             print("Request: \(String(describing: response.request))")   // original url request
             print("Response: \(String(describing: response.response))") // http url response
             print("Result: \(response.result)")                         // response serialization result

//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//             }
            
            switch response.result {
            case .success(let count):
                print("\(count) unread messages.")
                ProgressHUD.success()
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.failed()
            }
            
             if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
               print("Data: \(utf8Text)") // original server data as UTF8 string
             }
        }
    }
}
