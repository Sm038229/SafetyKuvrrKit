//
//  SKERPModels.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import Foundation

struct SKERPRequest: Codable {
    var plansOnly: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var uuid: String? = nil
    var version: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case plansOnly = "plans_only"
        case latitude = "lat"
        case longitude = "lng"
        case uuid = "uuid"
        case version = "version"
    }
}

struct SKERPListResponse: Codable {
    let uuid: String? = nil
    let orgUUID: String? = nil
    let sortKey: Int? = nil
    let title: String? = nil
    let banner: String? = nil
    let iconURLString: String? = nil
    let version: Int? = nil
    let jsonData: [String]? = nil
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case orgUUID = "organization_uuid"
        case sortKey = "sortkey"
        case title = "title"
        case banner = "banner"
        case iconURLString = "icon"
        case version = "version"
        case jsonData = "json_data"
    }
}
