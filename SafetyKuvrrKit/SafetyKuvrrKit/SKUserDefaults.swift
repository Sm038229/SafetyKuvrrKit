//
//  SKUserDefaults.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 02/07/24.
//

import Foundation

struct SKUserDefaults {
    private static let csrfToken = "kSKCsrfToken"
    private static let otpVerification = "kOTPVerification"
    
    private static func saveData(_ data: Any, forKey key: String) {
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    private static func getData(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    private static func removeData(forKey key: String) {
        return UserDefaults.standard.removeObject(forKey: key)
    }
}

extension SKUserDefaults {
    static func saveCSRFToken(_ token: String) {
        SKUserDefaults.saveData(token, forKey: SKUserDefaults.csrfToken)
    }
    
    static func getCSRFToken() -> String? {
        return SKUserDefaults.getData(forKey: SKUserDefaults.csrfToken) as? String
    }
    
    static func removeCSRFToken() {
        return SKUserDefaults.removeData(forKey: SKUserDefaults.csrfToken)
    }
    //
    static func saveOTPVerification(_ token: Bool) {
        SKUserDefaults.saveData(token, forKey: SKUserDefaults.otpVerification)
    }
    
    static func getOTPVerification() -> Bool? {
        return SKUserDefaults.getData(forKey: SKUserDefaults.otpVerification) as? Bool
    }
    
    static func removeOTPVerification() {
        return SKUserDefaults.removeData(forKey: SKUserDefaults.otpVerification)
    }
}
