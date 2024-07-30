//
//  SKFlic1.0.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation
import fliclib

final class SKFlic1_0: NSObject {
    static let shared = SKFlic1_0()
    
    private override init() {}
    
    static func initFlic1_0() {
        SCLFlicManager.configure(with: SKFlic1_0.shared, defaultButtonDelegate: SKFlic1_0.shared, appID: SKFlicManager.flicAppID, appSecret: SKFlicManager.flicAppSecret, backgroundExecution: true)
    }
    
    static func startScan() {
        SCLFlicManager.shared()?.startScan()
        var seconds = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds += 1
            if seconds == 15 {
                SKFlic1_0.stopScan()
                timer.invalidate()
            }
        }
    }
    
    static func stopScan() {
        SCLFlicManager.shared()?.stopScan()
    }
    
    private func kuvrrButton(from button:SCLFlicButton) -> SKKuvrrButton {
        return SKKuvrrButton(name: button.name, identifier: button.buttonIdentifier)
    }
}

extension SKFlic1_0: SCLFlicButtonDelegate {
    // Optional
    
    func flicButtonDidConnect(_ button: SCLFlicButton) {
        SKKuvrrButtonHandler.buttonDidConnect(kuvrrButton(from: button))
    }
    func flicButtonIsReady(_ button: SCLFlicButton) {
        SKKuvrrButtonHandler.buttonIsReady(kuvrrButton(from: button))
    }
    
    func flicButton(_ button: SCLFlicButton, didDisconnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didDisconnectWithError: error)
    }
    
    func flicButton(_ button: SCLFlicButton, didFailToConnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didFailToConnectWithError: error)
    }
    
    // Optional
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonClick: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonDoubleClick: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonHold queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonHold: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonUp queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonUp: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonDown queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonDown: queued, age: age)
    }
}

extension SKFlic1_0: SCLFlicManagerDelegate {
    func flicManager(_ manager: SCLFlicManager, didDiscover button: SCLFlicButton, withRSSI RSSI: NSNumber?) {
        
    }
    
    func flicManagerDidRestoreState(_ manager: SCLFlicManager) {
        
    }
    
    func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState) {
        
    }
    
    func flicManager(_ manager: SCLFlicManager, didForgetButton buttonIdentifier: UUID, error: (any Error)?) {
        
    }
}
