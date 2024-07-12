//
//  SKUserDefaults.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 02/07/24.
//

import Foundation

struct SKUserDefaults {
    private struct Key {
        static let csrfToken = "kSKCsrfToken"
        static let deviceUUID = "kSKDeviceUUID"
        static let userUUID = "kSKUserUUID"
    }
    
    private static func saveData(_ data: Any, forKey key: String) {
        UserDefaults.standard.setValue(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private static func getData(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    private static func removeData(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension SKUserDefaults {
    static var csrfToken: String? {
        get {
            return SKUserDefaults.getData(forKey: SKUserDefaults.Key.csrfToken) as? String
        }
        set {
            SKUserDefaults.saveData(newValue as Any, forKey: SKUserDefaults.Key.csrfToken)
        }
    }
    
    static func removeCSRFToken() {
        SKUserDefaults.removeData(forKey: SKUserDefaults.Key.csrfToken)
    }
    //
    static var deviceUUID: String? {
        get {
            return SKUserDefaults.getData(forKey: SKUserDefaults.Key.deviceUUID) as? String
        }
        set {
            SKUserDefaults.saveData(newValue as Any, forKey: SKUserDefaults.Key.deviceUUID)
        }
    }
    
    static func removeDeviceUUID() {
        SKUserDefaults.removeData(forKey: SKUserDefaults.Key.deviceUUID)
    }
    //
    static var userUUID: String? {
        get {
            return SKUserDefaults.getData(forKey: SKUserDefaults.Key.userUUID) as? String
        }
        set {
            SKUserDefaults.saveData(newValue as Any, forKey: SKUserDefaults.Key.userUUID)
        }
    }
    
    static func removeUserUUID() {
        SKUserDefaults.removeData(forKey: SKUserDefaults.Key.userUUID)
    }
    //
}
