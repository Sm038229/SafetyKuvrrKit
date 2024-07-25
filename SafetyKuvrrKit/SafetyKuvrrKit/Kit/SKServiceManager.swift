//
//  SKServiceManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import Foundation
import UIKit

struct SKServiceManager {
    private init() {}
    
    static func initialize() {
        if SKServiceManager.isUserLoggedIn == true {
            SKServiceManager.updateUserDeviceDetailAPI(success: {
                
            }, failure: { error in
                //guard let error = error else { failure(nil); return; }
            })
        } else {
            SKServiceManager.verifyOTP(email: "sachin@kuvrr.com", otp: "159753") { response in
                
            } failure: { error in
                
            }
        }
    }
    
    static var isUserLoggedIn: Bool {
        get {
            if SKUserDefaults.userUUID == nil {
                return false
            } else {
                return true
            }
        }
    }
    
    private static func sessionAPI(success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        SKService.apiCall(with: SKConstants.API.sessionInit, responseModel: SKCSRFToken.self) { response in
            guard let response = response, let token = response.token else { return }
            SKUserDefaults.csrfToken = token
            success()
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    private static func updateUserDeviceDetailAPI(success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        guard let userUUID = SKUserDefaults.userUUID else { return }
        let params = SKUserDevicedetailRequest(
            appCurrentVersion: UIDevice.current.appVersionWithBuildNumber,
            appVersionMajor: UIDevice.current.appVersionMajor,
            appVersionMinor: UIDevice.current.appVersionMinor,
            appVersionPoint: UIDevice.current.appVersionPoint,
            osVersionMajor: UIDevice.current.osVersionMajor,
            osVersionMinor: UIDevice.current.osVersionMinor,
            osVersionPoint: UIDevice.current.osVersionPoint,
            deviceType: UIDevice.current.deviceType,
            osType: UIDevice.current.osType,
            deviceModel: UIDevice.current.deviceModel,
            userUUID: userUUID,
            pushEnabled: false,
            nativeDeviceID: UIDevice.current.nativeDeviceID,
            pushID: nil,
            voipPushID: nil
        )
        SKService.apiCall(with: SKConstants.API.userDevice, method: SKUserDefaults.deviceUUID == nil ? .post : .put, parameters: params.dictionary, responseModel: SKUserDeviceDetailResponse.self) { response in
            guard let response = response, let uuid = response.uuid else { return }
            SKUserDefaults.deviceUUID = uuid
            success()
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func login(withEmail email: String? = nil, withMoble mobile: String? = nil, country: String = "IN", success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        var request: [String : Any] = [:]
        if let email = email {
            request = SKEmailLoginRequest(email: email).dictionary
        } else if let mobile = mobile {
            request = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile).dictionary
        }
        SKService.apiCall(with: SKConstants.API.login, method: .post, parameters: request) { response in
            guard let response = response else { success(nil); return; }
            success(response.message)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func verifyOTP(email: String? = nil, mobile: String? = nil, country: String = "IN", otp: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKServiceManager.sessionAPI(success: {
            var request: [String : Any] = [:]
            if let email = email {
                request = SKEmailOTPRequest(email: email, otp: otp).dictionary
            } else if let mobile = mobile {
                request = SKPhoneOTPRequest(countryCode: country, mobileNumber: mobile, otp: otp).dictionary
            }
            SKService.apiCall(with: SKConstants.API.otpVerify, method: .post, parameters: request, responseModel: SKVerifyOTPResponse.self) { response in
                guard let response = response else { success(nil); return; }
                SKUserDefaults.userUUID = response.userUUID
                //
                SKServiceManager.initialize()
                success(response.userUUID)
            } failure: { error in
                guard let error = error else { failure(nil); return; }
                failure(error)
            }
        }, failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        })
    }
    
    static func resendOTP(forEmail email: String? = nil, forMoble mobile: String? = nil, country: String = "IN", success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        var request: [String : Any] = [:]
        if let email = email {
            request = SKEmailLoginRequest(email: email).dictionary
        } else if let mobile = mobile {
            request = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile).dictionary
        }
        SKService.apiCall(with: SKConstants.API.otpResend, method: .post, parameters: request) { response in
            guard let response = response else { success(nil); return; }
            success(response.message)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func raiseEvent(isSoS: Bool = false, isWalkSafe: Bool = false, isTimer: Bool = false, isMedical: Bool = false, isCheckIn: Bool = false, isCheckOut: Bool = false, isEMS: Bool = false, emsNumber number: Int? = 0, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        if SKServiceManager.isUserLoggedIn == false {
            failure("Please Login first!")
            return
        }
        //
        var responderType = ""
        if let emsNumber = number, emsNumber > 0, isEMS == true {
            responderType = "\(emsNumber)"
            responderType.call()
        }
        else if isSoS == true { responderType = SKConstants.ResponderType._sos }
        else if isWalkSafe == true { responderType = SKConstants.ResponderType._walk_safe }
        else if isTimer == true { responderType = SKConstants.ResponderType._timer }
        else if isMedical == true { responderType = SKConstants.ResponderType._medical }
        else if isCheckIn == true { responderType = SKConstants.ResponderType._check_in }
        else if isCheckOut == true { responderType = SKConstants.ResponderType._check_out }
        else { failure("Undefined value") }
        //
        var mediaType = ""
        if (isSoS == true || isWalkSafe == true || isTimer == true) && UIApplication.shared.applicationState != .background {
            mediaType = "Video"
        }
        SKServiceManager.makeEvent(isEMS: isEMS, mediaType: mediaType, responderType: responderType) { response in
            success(response)
        } failure: { error in
            failure(error)
        }
    }
    
    private static func makeEvent(isEMS: Bool, mediaType: String, responderType : String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKLocationManager.currentLocation { currentLocation in
            let request = SKEventRequest(
                isEMS: isEMS,
                mediaType: mediaType,
                responderType: responderType,
                deviceUUID: SKUserDefaults.deviceUUID ?? "",
                pbTrigger: nil,
                appLocationOnly: nil,
                directionDegrees: nil,
                eventUUID: nil,
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude,
                altitude: currentLocation.altitude,
                horizontalAccuracy: currentLocation.horizontalAccuracy,
                verticalAccuracy: currentLocation.verticalAccuracy,
                course: currentLocation.course
            )
            SKServiceManager.raiseEvent(forData: request, success: { response in
                success(response)
            }, failure: { error in
                guard let error = error else { failure(nil); return; }
                failure(error)
            })
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    private static func raiseEvent(forData params: SKEventRequest, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKService.apiCall(with: SKConstants.API.incident, method: .post, parameters: params.dictionary, responseModel: SKEventResponse.self) { response in
            guard let response = response else { success(nil); return; }
            SKStreaming.eventResponse = response
            let request = SKStartEventRequest(mediaType: params.mediaType, eventUUID: response.uuid)
            SKServiceManager.startMediaEvent(forRequest: request)
            success(response.message)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func endEvent(forReason reason: String, andMessage message: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKStreaming.eventResponse?.reason = reason
        SKStreaming.eventResponse?.reasonMessage = message
        SKService.apiCall(with: SKConstants.API.incident + SKStreaming.eventResponse!.uuid!, method: .put, parameters: SKStreaming.eventResponse!.dictionary, responseModel: SKEventResponse.self) { response in
            guard let response = response else { success(nil); return; }
            success(response.message)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    private static func startMediaEvent(forRequest request: SKStartEventRequest) {
        if request.mediaType == "Video" {
            SKServiceManager.eventMediaStart(forData: request.dictionary) { response in
                SKStreaming.presentViewController()
            } failure: { error in
                
            }
        }
    }
    
    private static func eventMediaStart(forData params: [String: Any]?, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKService.apiCall(with: SKConstants.API.incidentMediaStart, method: .post, parameters: params, responseModel: SKStartEventResponse.self) { response in
            guard let response = response else { success(nil); return; }
            success(response.message)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func eventMediaStop(forEventUUID uuid: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKService.apiCall(with: "\(SKConstants.API.incidentMediaStop)/\(uuid)") { response in
            guard let response = response else { success(nil); return; }
            success(response.message)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func erpList(success: @escaping(([SKERPListResponse]?) -> Void), failure: @escaping((String?)-> Void)) {
        SKLocationManager.currentLocation { currentLocation in
            let request = SKERPRequest(plansOnly: "1", latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            SKService.apiCall(with: SKConstants.API.erp, method: .post, parameters: request.dictionary, responseModel: [SKERPListResponse].self) { response in
                guard let response = response else { success(nil); return; }
                success(response)
            } failure: { error in
                guard let error = error else { failure(nil); return; }
                failure(error)
            }
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func erpSelection(forUUID uuid: String, success: @escaping((SKERPListResponse?) -> Void), failure: @escaping((String?)-> Void)) {
        let request = SKERPRequest(plansOnly: "1")
        SKService.apiCall(with: SKConstants.API.erp + uuid, parameters: request.dictionary, responseModel: SKERPListResponse.self) { response in
            guard let response = response else { success(nil); return; }
            success(response)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
    
    static func erpAcknowledgement(forVersion version: Int, andUUID uuid: String, success: @escaping((SKERPAcknowledgementResponse?) -> Void), failure: @escaping((String?)-> Void)) {
        let request = SKERPRequest(version: version)
        SKService.apiCall(with: SKConstants.API.erp + uuid, method: .put, parameters: request.dictionary, responseModel: SKERPAcknowledgementResponse.self) { response in
            guard let response = response else { success(nil); return; }
            success(response)
        } failure: { error in
            guard let error = error else { failure(nil); return; }
            failure(error)
        }
    }
}
