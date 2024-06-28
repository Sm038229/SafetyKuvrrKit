//
//  SKTesting.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation

public struct SKTesting {
    public static func logMessage() {
        print("Hello this is testing message...")
        SKService.apiCall(with: "https://jsonplaceholder.typicode.com/todos/1", responseModel: SKDataResponse.self) { response in
            guard let response = response else { return }
            print("Success: \(response)")
        } failure: { error in
            print("Failure: \(error)")
        }
    }
}

struct SKDataResponse: Decodable {
    let completed: Bool
    let id: Int
    let userId: Int
    let title: String
}

