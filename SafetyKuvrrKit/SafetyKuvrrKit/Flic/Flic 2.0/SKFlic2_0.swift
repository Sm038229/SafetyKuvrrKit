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
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds += 1
            if seconds == 15 {
                SKFlic2_0.stopScan()
                timer.invalidate()
            }
        }
    }
    
    static func stopScan() {
        FLICManager.shared()?.stopScan()
    }
    
    private func kuvrrButton(from button:FLICButton) -> SKKuvrrButton {
        return SKKuvrrButton(name: button.name, identifier: button.identifier)
    }
}

extension SKFlic2_0: FLICButtonDelegate {
    // Required
    
    func buttonDidConnect(_ button: FLICButton) {
        SKKuvrrButtonHandler.buttonDidConnect(kuvrrButton(from: button))
    }
    
    func buttonIsReady(_ button: FLICButton) {
        SKKuvrrButtonHandler.buttonIsReady(kuvrrButton(from: button))
    }
    
    func button(_ button: FLICButton, didDisconnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didDisconnectWithError: error)
    }
    
    func button(_ button: FLICButton, didFailToConnectWithError error: (any Error)?) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didFailToConnectWithError: error)
    }
    
    // Optional
    
    func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonClick: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonDoubleClick: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonHold queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonHold: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonUp queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonUp: queued, age: age)
    }
    
    func button(_ button: FLICButton, didReceiveButtonDown queued: Bool, age: Int) {
        SKKuvrrButtonHandler.button(kuvrrButton(from: button), didReceiveButtonDown: queued, age: age)
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
