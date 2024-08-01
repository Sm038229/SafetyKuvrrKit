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
    
    private override init() {}
    
    static func initFlic1_0() {
        SCLFlicManager.configure(with: SKFlic1_0.shared, defaultButtonDelegate: SKFlic1_0.shared, appID: SKFlicManager.flicAppID, appSecret: SKFlicManager.flicAppSecret, backgroundExecution: true)
    }
    
    static func startScan() {
        SCLFlicManager.shared()?.startScan()
        SKFlic1_0.perform(#selector(SKFlic1_0.stopScan), with: nil, afterDelay: 15)
    }
    
    @objc static func stopScan() {
        SCLFlicManager.shared()?.stopScan()
        SKKuvrrButtonHandler.finishKuvrrPanicButtonScanning()
        SKFlic1_0.cancelPreviousPerformRequests(withTarget: self)
        SKFlic2_0.stopScan2_0()
    }
    
    static func stopScan1_0() {
        SCLFlicManager.shared()?.stopScan()
        SKFlic1_0.cancelPreviousPerformRequests(withTarget: self)
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
        return SKKuvrrButton(
            name: button.name,
            identifier: button.buttonIdentifier,
            batteryStatus: SKFlic1_0.kuvrrButtonBatteryStatus(from: button),
            batteryStatusColor: SKFlic1_0.kuvrrButtonBatteryStatusColor(from: button),
            flic1_0: button,
            flic2_0: nil,
            batteryVoltage: SKFlic1_0.kuvrrButtonBatteryStatus(from: button)
        )
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
        if SKFlic1_0.getConectedButtons().count > 0 {
            SKKuvrrButtonHandler.managerDidRestoreState()
        }
    }
    
    func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState) {
        if SKFlic1_0.getConectedButtons().count > 0 {
            switch state {
            case .poweredOn:
                print("Powered On FLIC 1.0 state")
            case .poweredOff:
                print("Powered Off FLIC 1.0 state")
            case .unsupported:
                print("Unsupported FLIC 1.0 state")
            case .unauthorized:
                print("Unauthorized FLIC 1.0 state")
            default:
                print("Unknown FLIC 1.0 state")
            }
        }
    }
    
    func flicManager(_ manager: SCLFlicManager, didForgetButton buttonIdentifier: UUID, error: (any Error)?) {
        
    }
}
