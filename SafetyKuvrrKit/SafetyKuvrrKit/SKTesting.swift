//
//  SKTesting.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation
import INTULocationManager

public struct SKTesting {
    private init() {}
    
    public static func initialize() {
        if SKTesting.isUserLoggedIn == true {
            SKTesting.updateUserDeviceDetailAPI(success: {
                
            }, failure: {
                
            })
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
    
    private static func sessionAPI(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        SKService.apiCall(with: SKConstants.API.sessionInit, responseModel: SKCSRFToken.self) { response in
            guard let response = response, let token = response.token else { return }
            SKUserDefaults.csrfToken = token
            print("Session Success: \(response)")
            success()
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure()
        }
    }
    
    private static func updateUserDeviceDetailAPI(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        guard let userUUID = SKUserDefaults.userUUID, SKPermission.isLocationAuthorized == true else { return }
        print("Authorization Success")
        SKTesting.sessionAPI(success: {
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
                failure()
            }
        }, failure: {
            failure()
        })
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
            failure()
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
                //
                SKPermission.requestLocation()
                SKTesting.updateUserDeviceDetailAPI(success: {
                    
                }, failure: {
                    
                })
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }, failure: {
            failure()
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
            failure()
        })
    }
    
    public static func call911(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            if (status == INTULocationStatus.success) {
                //let myLocation = SKLocation(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, altitude: currentLocation?.altitude ?? 0.0, verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0, horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0)
                let request = SKEMSRequest(
                    altitude: currentLocation?.altitude ?? 0.0,
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
                    verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0
                )
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
            failure()
        })
    }
}
