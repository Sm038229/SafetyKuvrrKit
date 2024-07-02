//
//  SKEncoder.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 02/07/24.
//

import Foundation

struct SKEncoder {
    static let shared = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: SKEncoder.shared.encode(self))) as? [String: Any] ?? [:]
    }
}
