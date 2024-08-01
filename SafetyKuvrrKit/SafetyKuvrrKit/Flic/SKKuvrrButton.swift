//
//  SKKuvrrButton.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation
import fliclib
import flic2lib

extension String {
    static let register = "register"
    static let deregister = "deregister"
    static let pair = "Pair"
    static let unpair = "UnPair"
    static let connect = "Connect"
    static let disconnect = "Disconnect"
    static let manual = "Manual"
    static let auto = "Auto"
}

struct SKKuvrrButton {
    let name: String
    let identifier: UUID
    let batteryStatus: String
    let batteryStatusColor: UIColor?
    let flic1_0: SCLFlicButton?
    let flic2_0: FLICButton?
    let batteryVoltage: String?
}

struct SKKuvrrButtonRegisterDeRegisterRequest: Codable {
    let name: String?
    let identifier: String?
    let nativeDeviceID: String? = UIDevice.current.nativeDeviceID
    let type: String? = "FLIC"
    var action: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case identifier = "device_id"
        case nativeDeviceID = "native_device_id"
        case type = "type"
        case action = "action"
    }
}

struct SKKuvrrButtonBatteryStatusRequest: Codable {
    let buttons: [SKKuvrrButtonStatusRequest]?
    
    enum CodingKeys: String, CodingKey {
        case buttons = "buttons"
    }
}

struct SKKuvrrButtonStatusRequest: Codable {
    let identifier: String?
    let batteryStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "flic_device_id"
        case batteryStatus = "battery_status"
    }
}

struct SKKuvrrButtonLogsRequest: Codable {
    let name: String?
    let identifier: String?
    let nativeDeviceID: String? = UIDevice.current.nativeDeviceID
    let type: String? = "FLIC 2"
    var action: String?
    let connectionType: String?
    let batteryStatus: String?
    let batteryValue: String?
    var source: String? = "iOS"
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case identifier = "device_id"
        case nativeDeviceID = "native_device_id"
        case type = "type"
        case action = "action"
        case connectionType = "connection_type"
        case batteryStatus = "battery_status"
        case batteryValue = "battery_value"
        case source = "source"
    }
}
