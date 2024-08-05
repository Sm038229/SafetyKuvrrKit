//
//  SKTesting.swift
//  SafetyKuvrr
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation

public struct SafetyKuvrr: SKKit {
    private init() {}
    
    public static var isUserLoggedIn: Bool {
        get {
            return SKServiceManager.isUserLoggedIn
        }
    }
    
    public static func initialize() {
        SKServiceManager.initialize()
    }
    
    public static func raiseSOS() {
        SKServiceManager.raiseEvent(isSoS: true) { response in
            
        } failure: { error in
            
        }
    }
    
    public static func raise911() {
        SKServiceManager.raiseEvent(isEMS: true, emsNumber: 911) { response in
            
        } failure: { error in
            
        }
    }
    
    public static func getERPList() {
        SKERPManager.presentERPListViewController()
    }
    
    public static func getMapList() {
        SKMapManager.presentMapListViewController()
    }
    
    public static func getKuvrrPanicButtonList() {
        SKKuvrrPanicButtonManager.presentKuvrrPanicButtonViewController()
    }
}
