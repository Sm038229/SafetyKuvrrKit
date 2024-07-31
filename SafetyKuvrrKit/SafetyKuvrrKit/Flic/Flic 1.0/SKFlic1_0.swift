//
//  SKFlic1.0.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation
import UIKit
import fliclib

final class SKFlic1_0: NSObject {
    static let shared = SKFlic1_0()
    var timer: Timer?
    
    private override init() {}
    
    static func initFlic1_0() {
        SCLFlicManager.configure(with: SKFlic1_0.shared, defaultButtonDelegate: SKFlic1_0.shared, appID: SKFlicManager.flicAppID, appSecret: SKFlicManager.flicAppSecret, backgroundExecution: true)
    }
    
    static func startScan() {
        SCLFlicManager.shared()?.startScan()
        var seconds = 0
        SKFlic1_0.shared.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds += 1
            if seconds == 15 {
                SKFlic1_0.stopScan()
                SKKuvrrButtonHandler.finishKuvrrPanicButtonScanning()
            }
        }
    }
    
    static func stopScan() {
        SCLFlicManager.shared()?.stopScan()
        SKFlic1_0.shared.timer?.invalidate()
    }
    
    static func getConectedButtons() -> [SKKuvrrButton] {
        var connectedButtons: [SKKuvrrButton] = []
        if let buttons = SCLFlicManager.shared()?.knownButtons() {
            for (uuid, button) in buttons {
                connectedButtons.append(SKFlic1_0.kuvrrButton(from: button))
            }
        }
        return connectedButtons
    }
    
    static func forget(kuvrrButton button:SKKuvrrButton, success: @escaping (() -> (Void)), failure: @escaping (() -> (Void))) {
        if let button1_0 = button.flic1_0 {
            SCLFlicManager.shared()?.forget(button1_0)
            success()
        } else {
            failure()
        }
    }
    
    private static func kuvrrButton(from button:SCLFlicButton) -> SKKuvrrButton {
        return SKKuvrrButton(name: button.name, identifier: button.buttonIdentifier, batteryStatus: SKFlic1_0.kuvrrButtonBatteryStatus(from: button), batteryStatusColor: SKFlic1_0.kuvrrButtonBatteryStatusColor(from: button), flic1_0: button, flic2_0: nil)
    }
    
    private static func kuvrrButtonBatteryStatus(from button:SCLFlicButton) -> String {
        switch button.batteryStatus {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        default:
            return "Unknown"
        }
    }
    
    private static func kuvrrButtonBatteryStatusColor(from button:SCLFlicButton) -> UIColor? {
        switch button.batteryStatus {
        case .low:
            return .batteryStatusLow
        case .medium:
            return .batteryStatusMedium
        case .high:
            return .batteryStatusHigh
        default:
            return .batteryStatusUnknown
        }
    }
}

extension SKFlic1_0: SCLFlicButtonDelegate {
    // Optional
    
    func flicButtonDidConnect(_ button: SCLFlicButton) {
        SKKuvrrButtonHandler.buttonDidConnect(SKFlic1_0.kuvrrButton(from: button))
    }
    func flicButtonIsReady(_ button: SCLFlicButton) {
        SKKuvrrButtonHandler.buttonIsReady(SKFlic1_0.kuvrrButton(from: button))
    }
    
    func flicButton(_ button: SCLFlicButton, didDisconnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didDisconnectWithError: error)
    }
    
    func flicButton(_ button: SCLFlicButton, didFailToConnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didFailToConnectWithError: error)
    }
    
    // Optional
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didReceiveButtonClick: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didReceiveButtonDoubleClick: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonHold queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didReceiveButtonHold: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonUp queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didReceiveButtonUp: queued, age: age)
    }
    
    func flicButton(_ button: SCLFlicButton, didReceiveButtonDown queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic1_0.kuvrrButton(from: button), didReceiveButtonDown: queued, age: age)
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
