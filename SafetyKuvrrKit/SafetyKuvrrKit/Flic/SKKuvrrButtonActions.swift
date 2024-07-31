//
//  SKKuvrrButtonActions.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation

protocol SKKuvrrButtonActions {
    //Button
    static func initializeKuvrrPanicButton()
    static func getAllConnectedButtons() -> [SKKuvrrButton]
    static func finishKuvrrPanicButtonScanning()
    static func startKuvrrPanicButtonScanning(success: @escaping ((String?) -> (Void)), failure: @escaping ((String?) -> (Void)))
    static func forget(kuvrrButton button:SKKuvrrButton, success: @escaping (() -> (Void)), failure: @escaping (() -> (Void)))
    static func buttonDidConnect(_ button: SKKuvrrButton)
    static func buttonIsReady(_ button: SKKuvrrButton)
    static func button(_ button: SKKuvrrButton, didDisconnectWithError error: (any Error)?)
    static func button(_ button: SKKuvrrButton, didFailToConnectWithError error: (any Error)?)
    static func button(_ button: SKKuvrrButton, didReceiveButtonClick queued: Bool, age: Int)
    static func button(_ button: SKKuvrrButton, didReceiveButtonDoubleClick queued: Bool, age: Int)
    static func button(_ button: SKKuvrrButton, didReceiveButtonHold queued: Bool, age: Int)
    static func button(_ button: SKKuvrrButton, didReceiveButtonUp queued: Bool, age: Int)
    static func button(_ button: SKKuvrrButton, didReceiveButtonDown queued: Bool, age: Int)
    
    //Manager
//    func flicManager(_ manager: SCLFlicManager, didDiscover button: SCLFlicButton, withRSSI RSSI: NSNumber?)
//    func flicManagerDidRestoreState(_ manager: SCLFlicManager)
//    func flicManager(_ manager: SCLFlicManager, didChange state: SCLFlicManagerBluetoothState)
//    func flicManager(_ manager: SCLFlicManager, didForgetButton buttonIdentifier: UUID, error: (any Error)?)
}
