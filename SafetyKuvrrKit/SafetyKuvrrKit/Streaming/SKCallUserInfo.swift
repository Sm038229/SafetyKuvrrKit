//
//  SKCallUserInfo.swift
//  SafetyKuvrr
//
//  Created by Sachchida Nand Mishra on 01/02/23.
//  Copyright © 2023 OPTiMO Information Technology. All rights reserved.
//

import Foundation

struct SKCallUserInfo: Codable {
    let uid : UInt
    var userName : String?
    var audioMute : Bool?
    var videoOff : Bool?
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case userName = "userName"
        case audioMute = "audioMute"
        case videoOff = "videoMute"
    }
}
