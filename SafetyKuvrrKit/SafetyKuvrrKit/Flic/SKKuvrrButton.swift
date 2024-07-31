//
//  SKKuvrrButton.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation
import fliclib
import flic2lib

struct SKKuvrrButton {
    let name: String
    let identifier: UUID
    let batteryStatus: String
    let batteryStatusColor: UIColor?
    let flic1_0: SCLFlicButton?
    let flic2_0: FLICButton?
}
