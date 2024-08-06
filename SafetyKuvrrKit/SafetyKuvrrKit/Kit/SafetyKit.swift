//
//  SafetyKit.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 07/08/24.
//

import Foundation

public struct SafetyKit {
    public static var isUserLoggedIn: Bool {
        get {
            return SafetyKuvrr.isUserLoggedIn
        }
    }
    
    public static func initialize() {
        SafetyKuvrr.initialize()
    }
    
    public static func raiseSOS() {
        SafetyKuvrr.raiseSOS()
    }
    
    public static func raise911() {
        SafetyKuvrr.raise911()
    }
    
    public static func getERPList() {
        SafetyKuvrr.getERPList()
    }
    
    public static func getMapList() {
        SafetyKuvrr.getMapList()
    }
    
    public static func getKuvrrPanicButtonList() {
        SafetyKuvrr.getKuvrrPanicButtonList()
    }
}
