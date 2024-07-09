//
//  SKTesting.swift
//  SafetyKuvrr
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation
import INTULocationManager

public struct SafetyKuvrr: SKKit {
    private init() {}
    
    public static func initialize() {
        SKPermission.requestLocation { status in
            if status == true, SafetyKuvrr.isUserLoggedIn == true, SKPermission.isLocationAuthorized == true {
                SafetyKuvrr.updateUserDeviceDetailAPI(success: {
                    
                }, failure: { error in
                    guard let error = error else { return }
                    print("Failure: \(error)")
                })
            }
        }
    }
    
    public static var isUserLoggedIn: Bool {
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
            print("Session Success: \(response)")
            success()
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure(error)
        }
    }
    
    private static func updateUserDeviceDetailAPI(success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        guard let userUUID = SKUserDefaults.userUUID else { return }
        print("Authorization Success")
        SafetyKuvrr.sessionAPI(success: {
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
                nativeDeviceID: nil,
                pushID: nil,
                voipPushID: nil
            )
            SKService.apiCall(with: SKConstants.API.userDevice, method: SKUserDefaults.deviceUUID == nil ? .post : .put, parameters: params.dictionary, responseModel: SKUserDeviceDetailResponse.self) { response in
                guard let response = response, let uuid = response.uuid else { return }
                SKUserDefaults.deviceUUID = uuid
                print("Update User Device Detail Success: \(response)")
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure(error)
            }
        }, failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure(error)
        })
    }
    
    public static func login(forMoble mobile: String, country: String = "IN", success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SafetyKuvrr.sessionAPI(success: {
            let loginRequest = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile)
            SKService.apiCall(with: SKConstants.API.login, method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("Login Success: \(response)")
                success(response.message)
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure(error)
            }
        }, failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure(error)
        })
    }
    
    public static func verifyOTP(mobile: String, country: String = "IN", otp: String, success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        SafetyKuvrr.sessionAPI(success: {
            let loginRequest = SKPhoneOTPRequest(countryCode: country, mobileNumber: mobile, otp: otp)
            SKService.apiCall(with: SKConstants.API.otpVerify, method: .post, parameters: loginRequest.dictionary, responseModel: SKVerifyOTPResponse.self) { response in
                guard let response = response else { return }
                print("OTP Verify Success: \(response)")
                SKUserDefaults.userUUID = response.userUUID
                SafetyKuvrr.initialize()
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure(error)
            }
        }, failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure(error)
        })
    }
    
    public static func resendOTP(forMoble mobile: String, country: String = "IN", success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        SafetyKuvrr.sessionAPI(success: {
            let loginRequest = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile)
            SKService.apiCall(with: SKConstants.API.otpResend, method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("OTP Resend Success: \(response)")
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure(error)
            }
        }, failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure(error)
        })
    }
    
    public static func raiseEvent(isSoS: Bool = false, isWalkSafe: Bool = false, isTimer: Bool = false, isMedical: Bool = false, isCheckIn: Bool = false, isCheckOut: Bool = false, isEMS: Bool = false, emsNumber number: Int? = 0, success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        var responderType = "\(number ?? 0)"
        if isSoS == true { responderType = SKConstants.ResponderType._sos }
        else if isWalkSafe == true { responderType = SKConstants.ResponderType._walk_safe }
        else if isTimer == true { responderType = SKConstants.ResponderType._timer }
        else if isMedical == true { responderType = SKConstants.ResponderType._medical }
        else if isCheckIn == true { responderType = SKConstants.ResponderType._check_in }
        else if isCheckOut == true { responderType = SKConstants.ResponderType._check_out }
        //
        var mediaType = ""
        if (isSoS == true || isWalkSafe == true || isTimer == true) && UIApplication.shared.applicationState != .background {
            mediaType = "Video"
        }
        SafetyKuvrr.makeEvent(isEMS: isEMS, mediaType: mediaType, responderType: responderType) {
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    private static func makeEvent(isEMS: Bool, mediaType: String, responderType : String, success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            if (status == INTULocationStatus.success) {
                let myLocation = SKLocation(
                    latitude: currentLocation?.coordinate.latitude ?? 0.0,
                    longitude: currentLocation?.coordinate.longitude ?? 0.0,
                    altitude: currentLocation?.altitude ?? 0.0,
                    verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0,
                    horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0
                )
                let request = SKEMSRequest(
                    isEMS: isEMS,
                    mediaType: mediaType,
                    pbTrigger: false,
                    responderType: responderType,
                    appLocationOnly: mediaType.isEmpty ? true : false,
                    deviceUUID: SKUserDefaults.deviceUUID ?? "",
                    directionDegrees: nil,
                    incidentUUID: nil,
                    latitude: myLocation.latitude,
                    longitude: myLocation.longitude,
                    altitude: myLocation.altitude,
                    horizontalAccuracy: myLocation.horizontalAccuracy,
                    verticalAccuracy: myLocation.verticalAccuracy
                )
                print("Current Location: \(request.dictionary)")
                SafetyKuvrr.raiseEvent(forData: request.dictionary, success: {
                    success()
                }, failure: { error in
                    guard let error = error else { return }
                    print("Failure: \(error)")
                    failure(error)
                })
            }
            else if (status == INTULocationStatus.timedOut) {
                failure("")
            }
            else {
                failure("")
            }
        }
    }
    
    private static func raiseEvent(forData params: [String: Any]?, success: @escaping(() -> Void), failure: @escaping((String?)-> Void)) {
        SafetyKuvrr.sessionAPI(success: {
            SKService.apiCall(with: SKConstants.API.incident, method: .post, parameters: params, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("Success: \(response)")
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure(error)
            }
        }, failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure(error)
        })
    }
}