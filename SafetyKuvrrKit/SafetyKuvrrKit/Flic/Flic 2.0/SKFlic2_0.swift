//
//  SKFlic2.0.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation
import flic2lib

final class SKFlic2_0: NSObject {
    static let shared = SKFlic2_0()
    var timer: Timer?
    
    private override init() {}
    
    static func initFlic2_0() {
        FLICManager.configure(with: SKFlic2_0.shared, buttonDelegate: SKFlic2_0.shared, background: true)
    }
    
    static func startScan() {
        FLICManager.shared()?.scanForButtons(stateChangeHandler: { event in
            switch event {
            case .discovered:
                print("Discovered FLIC 2.0 Event")
            case .connected:
                print("Connected FLIC 2.0 Event")
            case .verified:
                print("Verified FLIC 2.0 Event")
            case .verificationFailed:
                print("Verification Failed FLIC 2.0 Event")
            default:
                print("Unknown FLIC 2.0 Event")
            }
        }, completion: { button, error in
            if let button = button {
                button.triggerMode = .clickAndDoubleClickAndHold
                SKFlic2_0.stopScan()
                SKFlic2_0.shared.buttonDidConnect(button)
            }
        })
        
        var seconds = 0
        SKFlic2_0.shared.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds += 1
            if seconds == 15 {
                SKFlic2_0.stopScan()
                SKKuvrrButtonHandler.finishKuvrrPanicButtonScanning()
            }
        }
    }
    
    static func stopScan() {
        FLICManager.shared()?.stopScan()
        SKFlic2_0.shared.timer?.invalidate()
    }
    
    static func getConectedButtons() -> [SKKuvrrButton] {
        var connectedButtons: [SKKuvrrButton] = []
        if let buttons = FLICManager.shared()?.buttons() {
            for button in buttons {
                connectedButtons.append(SKFlic2_0.kuvrrButton(from: button))
            }
        }
        return connectedButtons
    }
    
    static func forget(kuvrrButton button:SKKuvrrButton, success: @escaping (() -> (Void)), failure: @escaping (() -> (Void))) {
        if let button2_0 = button.flic2_0 {
            FLICManager.shared()?.forgetButton(button2_0, completion: { uuid, error in
                if error == nil {
                    success()
                } else {
                    failure()
                }
            })
        } else {
            failure()
        }
    }
    
    private static func kuvrrButton(from button:FLICButton) -> SKKuvrrButton {
        return SKKuvrrButton(name: button.name ?? "Un-Named", identifier: button.identifier, batteryStatus: SKFlic2_0.kuvrrButtonBatteryStatus(from: button), batteryStatusColor: SKFlic2_0.kuvrrButtonBatteryStatusColor(from: button), flic1_0: nil, flic2_0: button)
    }
    
    private static func kuvrrButtonBatteryStatus(from button:FLICButton) -> String {
        switch button.batteryVoltage * 100 {
        case 1...265:
            return "Low"
        case 266...287:
            return "Medium"
        case 288...310:
            return "High"
        default:
            return "Unknown"
        }
    }
    
    private static func kuvrrButtonBatteryStatusColor(from button:FLICButton) -> UIColor? {
        switch button.batteryVoltage * 100 {
        case 1...265:
            return .batteryStatusLow
        case 266...287:
            return .batteryStatusMedium
        case 288...310:
            return .batteryStatusHigh
        default:
            return .batteryStatusUnknown
        }
    }
}

extension SKFlic2_0: FLICButtonDelegate {
    // Required
    
    func buttonDidConnect(_ button: FLICButton) {
        SKKuvrrButtonHandler.buttonDidConnect(SKFlic2_0.kuvrrButton(from: button))
    }
    
    func buttonIsReady(_ button: FLICButton) {
        SKKuvrrButtonHandler.buttonIsReady(SKFlic2_0.kuvrrButton(from: button))
    }
    
    func button(_ button: FLICButton, didDisconnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didDisconnectWithError: error)
    }
    
    func button(_ button: FLICButton, didFailToConnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didFailToConnectWithError: error)
    }
    
    // Optional
    
    func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didReceiveButtonClick: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didReceiveButtonDoubleClick: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonHold queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didReceiveButtonHold: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonUp queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didReceiveButtonUp: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonDown queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(SKFlic2_0.kuvrrButton(from: button), didReceiveButtonDown: queued, age: age)
    }
}

extension SKFlic2_0: FLICManagerDelegate {
    func managerDidRestoreState(_ manager: FLICManager) {
        
    }
    
    func manager(_ manager: FLICManager, didUpdate state: FLICManagerState) {
        switch state {
        case .poweredOn:
            print("Powered On FLIC 2.0 state")
        case .poweredOff:
            print("Powered Off FLIC 2.0 state")
        case .unsupported:
            print("Unsupported FLIC 2.0 state")
        case .unauthorized:
            print("Unauthorized FLIC 2.0 state")
        default:
            print("Unknown FLIC 2.0 state")
        }
    }
}
