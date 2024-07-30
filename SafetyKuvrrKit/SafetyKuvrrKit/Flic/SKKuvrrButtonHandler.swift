//
//  SKKuvrrButtonHandler.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation

struct SKKuvrrButtonHandler: SKKuvrrButtonActions {
    static var successHandler: (() -> (Void))?
    static var failureHandler: (() -> (Void))?
    
    static func initializeKuvrrPanicButton() {
        print("initializeKuvrrPanicButton")
        SKFlic1_0.initFlic1_0()
        SKFlic2_0.initFlic2_0()
    }
    
    static func startKuvrrPanicButtonScanning(success: @escaping (() -> (Void)), failure: @escaping (() -> (Void))) {
        SKKuvrrButtonHandler.successHandler = success
        SKKuvrrButtonHandler.failureHandler = failure
        print("startScanning")
        SKFlic1_0.startScan()
        SKFlic2_0.startScan()
    }
    
    static func buttonDidConnect(_ button: SKKuvrrButton) {
        print("buttonDidConnect")
        SKKuvrrButtonHandler.successHandler?()
    }
    
    static func buttonIsReady(_ button: SKKuvrrButton) {
        print("buttonIsReady")
    }
    
    static func button(_ button: SKKuvrrButton, didDisconnectWithError error: (any Error)?) {
        print("didDisconnectWithError")
    }
    
    static func button(_ button: SKKuvrrButton, didFailToConnectWithError error: (any Error)?) {
        print("didFailToConnectWithError")
        SKKuvrrButtonHandler.failureHandler?()
    }
    
    static func button(_ button: SKKuvrrButton, didReceiveButtonClick queued: Bool, age: Int) {
        print("didReceiveButtonClick")
    }
    
    static func button(_ button: SKKuvrrButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
        print("didReceiveButtonDoubleClick")
    }
    
    static func button(_ button: SKKuvrrButton, didReceiveButtonHold queued: Bool, age: Int) {
        print("didReceiveButtonHold")
        SafetyKuvrr.raiseEvent(isSoS: true) { response in
            
        } failure: { error in
            
        }
    }
    
    static func button(_ button: SKKuvrrButton, didReceiveButtonUp queued: Bool, age: Int) {
        print("didReceiveButtonUp")
    }
    
    static func button(_ button: SKKuvrrButton, didReceiveButtonDown queued: Bool, age: Int) {
        print("didReceiveButtonDown")
    }
}
