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
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case verticalAccuracy
        case horizontalAccuracy
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
    let uuid: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
    }
}

struct SKEMSRequest: Codable {
    let altitude: Double
    let appLocationOnly: Bool
    let deviceUUID: String
    let directionDegrees: Double?
    let ems: Bool
    let horizontalAccuracy: Double
    let incidentUUID: String?
    let latitude: Double
    let longitude: Double
    let mediaType: String
    let pbTrigger: Bool
    let responderType: String
    let verticalAccuracy: Double
    
    enum CodingKeys: String, CodingKey {
        case altitude = "altitude"
        case appLocationOnly = "app_location_only"
        case deviceUUID = "device_uuid"
        case directionDegrees = "direction_degrees"
        case ems = "ems"
        case horizontalAccuracy = "horizontal_accuracy"
        case incidentUUID = "incident_uuid"
        case latitude = "lat"
        case longitude = "lng"
        case mediaType = "media_type"
        case pbTrigger = "pb_trigger"
        case responderType = "responder_type"
        case verticalAccuracy = "vertical_accuracy"
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
