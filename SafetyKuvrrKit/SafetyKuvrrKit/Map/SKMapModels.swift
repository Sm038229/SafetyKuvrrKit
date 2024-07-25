//
//  SKMapModels.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation

struct SKMapRequest: Codable {
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct SKMapListResponse: Codable {
    var mapList: [SKMapInfoResponse]?
    let userName: String?
    let userUUID: String?
    
    enum CodingKeys: String, CodingKey {
        case mapList = "maps"
        case userName = "user_name"
        case userUUID = "user_uuid"
    }
}

struct SKMapInfoResponse: Codable {
    let mapID: String?
    let mapZoomLevel: Int?
    let mapDescription: String?
    let mapAccessToken: String?
    let mapLattitude: String?
    let mapLiveAccessToken: String?
    let mapLongitude: String?
    let mapRegion: String?
    let mapType: String?
    let mapURL: String?
    let mapName: String?
    let mapUUID: String?
    
    enum CodingKeys: String, CodingKey {
        case mapID = "map_id"
        case mapZoomLevel = "map_zoom"
        case mapDescription = "description"
        case mapAccessToken = "map_key"
        case mapLattitude = "map_lat"
        case mapLiveAccessToken = "map_live_key"
        case mapLongitude = "map_lng"
        case mapRegion = "map_region"
        case mapType = "map_type"
        case mapURL = "map_url"
        case mapName = "name"
        case mapUUID = "uuid"
    }
}
