//
//  SKTesting.swift
//  SafetyKuvrr
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation

struct SafetyKuvrr: SKKit {
    private init() {}
    
    static var isUserLoggedIn: Bool {
        get {
            return SKServiceManager.isUserLoggedIn
        }
    }
    
    static func initialize() {
        SKServiceManager.initialize()
    }
    
    static func raiseSOS() {
        SKServiceManager.raiseEvent(isSoS: true) { response in
            
        } failure: { error in
            
        }
    }
    
    static func raise911() {
        SKServiceManager.raiseEvent(isEMS: true, emsNumber: 911) { response in
            
        } failure: { error in
            
        }
    }
    
    static func getERPList() {
        SKERPManager.presentERPListViewController()
    }
    
    static func getMapList() {
        SKMapManager.presentMapListViewController()
    }
    
    static func getKuvrrPanicButtonList() {
        SKKuvrrPanicButtonManager.presentKuvrrPanicButtonViewController()
    }
}
