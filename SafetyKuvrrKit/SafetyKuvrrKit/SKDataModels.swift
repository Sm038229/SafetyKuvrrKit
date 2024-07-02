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
