//
//  SKDataModels.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 02/07/24.
//

import Foundation

struct SKMessage: Decodable {
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

struct SKErrorMessage: Decodable {
    let errorMessage: [String]?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "errors"
    }
}

struct SKCSRFToken: Decodable {
    let token: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "csrf_token"
        case message = "message"
    }
}

struct SKLocation: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let verticalAccuracy: Double
    let horizontalAccuracy: Double
    let course: Double
    let directionDegrees: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case verticalAccuracy
        case horizontalAccuracy
        case course
        case directionDegrees
    }
}

struct SKPhoneLoginRequest: Codable {
    let countryCode: String
    let mobileNumber: String
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case mobileNumber = "phone"
    }
}

struct SKEmailLoginRequest: Codable {
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
}

struct SKVerifyOTPResponse: Decodable {
    let phoneInfo: SKVerifyOTPPhoneInfo
    let style: SKVerifyOTPStyleInfo
    let hasOrg: Bool
    let blootoothPermission: Bool
    let bucket: String
    let userUUID: String
    
    enum CodingKeys: String, CodingKey {
        case phoneInfo = "phone_info"
        case style = "style"
        case hasOrg = "has_org"
        case blootoothPermission = "ble_permission"
        case bucket = "bucket"
        case userUUID = "user_uuid"
    }
    //
    
    struct SKVerifyOTPPhoneInfo: Decodable {
        let countryCode: String
        let phone: String
        let message: String
        let verified: Bool
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "country_code"
            case phone = "phone"
            case message = "message"
            case verified = "verified"
        }
    }
    //
    
    struct SKVerifyOTPStyleInfo: Decodable {
        let backGroundColor: String
        
        enum CodingKeys: String, CodingKey {
            case backGroundColor = "backGroundColor"
        }
    }
}

struct SKPhoneOTPRequest: Codable {
    let countryCode: String
    let mobileNumber: String
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case mobileNumber = "phone"
        case otp = "otp"
    }
}

struct SKEmailOTPRequest: Codable {
    let email: String
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case otp = "otp"
    }
}

struct SKUserDeviceDetailResponse: Codable {
    let user: String?
    let userUUID: String?
    let url: String?
    let uuid: String?
    let created: String?
    let phoneNumber: String?
    let nativeDeviceID: String?
    let deviceType: String?
    let osType: String?
    let osVersionMajor: Int?
    let osVersionMinor: Int?
    let osVersionPoint: Int?
    let appVersionMajor: Int?
    let appVersionMinor: Int?
    let appVersionPoint: Int?
    let phoneModel: String?
    let pushID: String?
    let voipPushID: String?
    let awsPushARN: String?
    let skipVersion: String?
    let currentVersion: String?
    let isActive: Bool?
    let pushEnabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case userUUID = "user_uuid"
        case url = "url"
        case uuid = "uuid"
        case created = "created"
        case phoneNumber = "phone_number"
        case nativeDeviceID = "native_device_id"
        case deviceType = "device_type"
        case osType = "os_type"
        case osVersionMajor = "os_version_major"
        case osVersionMinor = "os_version_minor"
        case osVersionPoint = "os_version_point"
        case appVersionMajor = "app_version_major"
        case appVersionMinor = "app_version_minor"
        case appVersionPoint = "app_version_point"
        case phoneModel = "phone_model"
        case pushID = "push_id"
        case voipPushID = "voip_push_id"
        case awsPushARN = "aws_push_arn"
        case skipVersion = "skip_version"
        case currentVersion = "current_version"
        case isActive = "is_active"
        case pushEnabled = "push_enabled"
    }
}

struct SKEventResponseMapDetails: Codable {
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "api_key"
    }
}

struct SKEventResponse: Codable {
    let dateCreated : String?
    let browsableURL : String?
    let token : String?
    var reason : String?
    var reasonMessage : String?
    let observingProOrg : String?
    let observingGeofence : String?
    let uuid : String?
    //let observersWatching : String?
    let eventURLString : String?
    let type : String?
    let eventType : String?
    let message : String?
    let organization : String?
    let isRead : Bool?
    let messageID : Int?
    let streamChannelName : String?
    let streamToken : String?
    let isTwoWayLiveStream : Bool?
    let isPortraitOnly : Bool?
    let mapDetails : SKEventResponseMapDetails?
    
    enum CodingKeys: String, CodingKey {
        case dateCreated = "created"
        case browsableURL = "browsable_url"
        case token = "token"
        case reason = "status"
        case reasonMessage = "status_message"
        case observingProOrg = "observing_pro_org"
        case observingGeofence = "observing_geofence"
        case uuid = "uuid"
        //case observersWatching = "observers_watching"
        case eventURLString = "url"
        case type = "type"
        case eventType = "event_type"
        case message = "message"
        case organization = "organization"
        case isRead = "is_read"
        case messageID = "id"
        case streamChannelName = "channel_name"
        case streamToken = "token_stream"
        case isTwoWayLiveStream = "two_way_live_stream"
        case isPortraitOnly = "portrait_only"
        case mapDetails = "map"
    }
}

struct SKEventRequest: Codable {
    let isEMS: Bool
    let mediaType: String
    let responderType: String
    let deviceUUID: String?
    let pbTrigger: Bool?
    let appLocationOnly: Bool?
    let directionDegrees: Double?
    let eventUUID: String?
    let latitude: Double?
    let longitude: Double?
    let altitude: Double?
    let horizontalAccuracy: Double?
    let verticalAccuracy: Double?
    let course: Double?
    
    enum CodingKeys: String, CodingKey {
        case isEMS = "ems"
        case mediaType = "media_type"
        case responderType = "responder_type"
        case deviceUUID = "device_uuid"
        case pbTrigger = "pb_trigger"
        case appLocationOnly = "app_location_only"
        case directionDegrees = "direction_degrees"
        case eventUUID = "incident_uuid"
        case latitude = "lat"
        case longitude = "lng"
        case altitude = "altitude"
        case horizontalAccuracy = "horizontal_accuracy"
        case verticalAccuracy = "vertical_accuracy"
        case course = "course"
    }
}

struct SKUserDevicedetailRequest: Codable {
    let appCurrentVersion: String?
    let appVersionMajor: String?
    let appVersionMinor: String?
    let appVersionPoint: String?
    let osVersionMajor: String?
    let osVersionMinor: String?
    let osVersionPoint: String?
    let deviceType: String?
    let osType: String?
    let deviceModel: String?
    let userUUID: String?
    let pushEnabled: Bool
    let nativeDeviceID: String?
    let pushID: String?
    let voipPushID: String?
    
    enum CodingKeys: String, CodingKey {
        case appCurrentVersion = "current_version"
        case appVersionMajor = "app_version_major"
        case appVersionMinor = "app_version_minor"
        case appVersionPoint = "app_version_point"
        case osVersionMajor = "os_version_major"
        case osVersionMinor = "os_version_minor"
        case osVersionPoint = "os_version_point"
        case deviceType = "device_type"
        case osType = "os_type"
        case deviceModel = "phone_model"
        case userUUID = "user_uuid"
        case pushEnabled = "push_enabled"
        case nativeDeviceID = "native_device_id"
        case pushID = "push_id"
        case voipPushID = "voip_push_id"
    }
}

struct SKStartEventResponse: Codable {
    let message: String?
    let allowedMinutes: Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case allowedMinutes = "max_live_stream_allow"
    }
}

struct SKStartEventRequest: Codable {
    let mediaType: String?
    let eventUUID: String?
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case eventUUID = "incident_id"
    }
}
