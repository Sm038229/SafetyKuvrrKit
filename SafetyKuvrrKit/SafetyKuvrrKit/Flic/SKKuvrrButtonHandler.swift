//
//  SKKuvrrButtonHandler.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation

struct SKKuvrrButtonHandler: SKKuvrrButtonActions {
    private static var successHandler: ((String?) -> (Void))?
    private static var failureHandler: ((String?) -> (Void))?
    
    static func initializeKuvrrPanicButton() {
        print("initializeKuvrrPanicButton")
        SKFlic1_0.initFlic1_0()
        SKFlic2_0.initFlic2_0()
    }
    
    static func getAllConnectedButtons() -> [SKKuvrrButton] {
        print("getAllConnectedButtons")
        var buttons: [SKKuvrrButton] = []
        buttons = SKFlic1_0.getConectedButtons() + SKFlic2_0.getConectedButtons()
        return buttons
    }
    
    static func finishKuvrrPanicButtonScanning() {
        print("finishKuvrrPanicButtonScanning")
        SKKuvrrButtonHandler.failureHandler?("Scanning finished!")
    }
    
    static func startKuvrrPanicButtonScanning(success: @escaping ((String?) -> (Void)), failure: @escaping ((String?) -> (Void))) {
        SKKuvrrButtonHandler.successHandler = success
        SKKuvrrButtonHandler.failureHandler = failure
        print("startKuvrrPanicButtonScanning")
        SKFlic1_0.startScan()
        SKFlic2_0.startScan()
    }
    
    static func forget(kuvrrButton button:SKKuvrrButton, success: @escaping (() -> (Void)), failure: @escaping (() -> (Void))) {
        if button.flic1_0 != nil {
            SKFlic1_0.forget(kuvrrButton: button) {
                success()
            } failure: {
                failure()
            }
        } else {
            SKFlic2_0.forget(kuvrrButton: button) {
                success()
            } failure: {
                failure()
            }
        }
    }
    
    static func buttonDidConnect(_ button: SKKuvrrButton) {
        print("buttonDidConnect")
        SKKuvrrButtonHandler.successHandler?("Pairing success")
    }
    
    static func buttonIsReady(_ button: SKKuvrrButton) {
        print("buttonIsReady")
    }
    
    static func button(_ button: SKKuvrrButton, didDisconnectWithError error: (any Error)?) {
        print("didDisconnectWithError")
    }
    
    static func button(_ button: SKKuvrrButton, didFailToConnectWithError error: (any Error)?) {
        print("didFailToConnectWithError")
        SKKuvrrButtonHandler.failureHandler?("didFailToConnectWithError : \(error?.localizedDescription ?? "")")
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
