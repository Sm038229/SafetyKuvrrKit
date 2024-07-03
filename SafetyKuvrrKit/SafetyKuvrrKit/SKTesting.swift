//
//  SKTesting.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation
import INTULocationManager

public struct SKTesting {
    static let shared = SKTesting()
    private init() {}
    
    public static func initialize() {
        SKTesting.sessionAPI(success: {
            
        }, failure: {
            
        })
    }
    
    public static var isUserLoggedIn: Bool {
        get {
            if SKUserDefaults.userUUID != nil && SKUserDefaults.deviceUUID != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    private static func sessionAPI(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        SKService.apiCall(with: SKConstants.API.sessionInit, responseModel: SKCSRFToken.self) { response in
            guard let response = response, let token = response.token else { return }
            SKUserDefaults.csrfToken = token
            print("Session Success: \(response)")
            if SKUserDefaults.userUUID != nil {
                SKTesting.updateUserDeviceDetailAPI(success: {
                    
                }, failure: {
                    
                })
            }
            success()
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure()
        }
    }
    
    private static func updateUserDeviceDetailAPI(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        guard let userUUID = SKUserDefaults.userUUID else {return}
        var methodTypePost = true
        if SKUserDefaults.deviceUUID == nil {
            methodTypePost = true
        } else {
            methodTypePost = false
        }
        //
        let params: [String: Any] = [
            "os_type" : "iOS",
            "device_type" : "Phone",
            "user_uuid" : userUUID
        ]
        SKService.apiCall(with: SKConstants.API.userDevice, method: methodTypePost == true ? .post : .put, parameters: params, responseModel: SKUserDeviceDetailResponse.self) { response in
            guard let response = response, let uuid = response.uuid else { return }
            SKUserDefaults.deviceUUID = uuid
            print("Update User Device Detail Success: \(response)")
            success()
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure()
        }
            
    }
    
    public static func callLogin(forMoble mobile: String, country: String = "IN", success: @escaping((String?) -> Void), failure: @escaping(()-> Void)) {
        SKTesting.sessionAPI(success: {
            let loginRequest = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile)
            SKService.apiCall(with: SKConstants.API.login, method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("Login Success: \(response)")
                success(response.message)
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }, failure: {
            
        })
    }
    
    public static func callVerifyOTP(mobile: String, country: String = "IN", otp: String, success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        SKTesting.sessionAPI(success: {
            let loginRequest = SKPhoneOTPRequest(countryCode: country, mobileNumber: mobile, otp: otp)
            SKService.apiCall(with: SKConstants.API.otpVerify, method: .post, parameters: loginRequest.dictionary, responseModel: SKVerifyOTPResponse.self) { response in
                guard let response = response else { return }
                print("OTP Verify Success: \(response)")
                SKUserDefaults.userUUID = response.userUUID
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }, failure: {
            
        })
    }
    
    public static func callResendOTP(forMoble mobile: String, country: String = "IN", success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        SKTesting.sessionAPI(success: {
            let loginRequest = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile)
            SKService.apiCall(with: SKConstants.API.otpResend, method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("OTP Resend Success: \(response)")
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }, failure: {
            
        })
    }
    
    public static func call911(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            if (status == INTULocationStatus.success) {
                //let myLocation = SKLocation(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, altitude: currentLocation?.altitude ?? 0.0, verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0, horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0)
                let request = SKEMSRequest(altitude: currentLocation?.altitude ?? 0.0,
                                           appLocationOnly: false,
                                           deviceUUID: SKUserDefaults.deviceUUID ?? "",
                                           directionDegrees: nil,
                                           ems: true,
                                           horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0,
                                           incidentUUID: nil,
                                           latitude: currentLocation?.coordinate.latitude ?? 0.0,
                                           longitude: currentLocation?.coordinate.longitude ?? 0.0,
                                           mediaType: "",
                                           pbTrigger: false,
                                           responderType: "911",
                                           verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0)
                print("Current Location: \(request.dictionary)")
                SKTesting.callEMS(forData: request.dictionary, success: {
                    success()
                }, failure: {
                    failure()
                })
            }
            else if (status == INTULocationStatus.timedOut) {
                
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
            }
        }
    }
    
    private static func callEMS(forData params: [String: Any]?, success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        SKTesting.sessionAPI(success: {
            SKService.apiCall(with: SKConstants.API.incident, method: .post, parameters: params, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("Success: \(response)")
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }, failure: {
            
        })
    }
}
