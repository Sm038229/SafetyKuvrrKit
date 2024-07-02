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
    private init() {
        SKTesting.sessionAPI(success: {
            
        }, failure: {
            
        })
    }
    
    public static func logMessage() {
        print("Hello this is testing message...")
    }
    
    private static func sessionAPI(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        if SKUserDefaults.getCSRFToken() == nil {
            SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/session_init/", responseModel: SKCSRFToken.self) { response in
                guard let response = response, let token = response.token else { return }
                SKUserDefaults.saveCSRFToken(token)
                print("Session Success: \(response)")
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
            return
        }
    }
    
    public static func callLogin(forMoble mobile: String, country: String = "IN", success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        let loginRequest = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile)
        SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/otp/login/", method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
            guard let response = response else { return }
            print("Login Success: \(response)")
            success()
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
            failure()
        }
    }
    
    public static func callVerifyOTP(mobile: String, country: String = "IN", otp: String, success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        if SKUserDefaults.getOTPVerification() != true {
            let loginRequest = SKPhoneOTPRequest(countryCode: country, mobileNumber: mobile, otp: otp)
            SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/otp/verify/", method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("OTP Verify Success: \(response)")
                SKUserDefaults.saveOTPVerification(true)
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }
    }
    
    public static func callResendOTP(forMoble mobile: String, country: String = "IN", success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        if SKUserDefaults.getOTPVerification() == false {
            let loginRequest = SKPhoneLoginRequest(countryCode: country, mobileNumber: mobile)
            SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/otp/resend/", method: .post, parameters: loginRequest.dictionary, responseModel: SKMessage.self) { response in
                guard let response = response else { return }
                print("OTP Verify Success: \(response)")
                SKUserDefaults.saveOTPVerification(true)
                success()
            } failure: { error in
                guard let error = error else { return }
                print("Failure: \(error)")
                failure()
            }
        }
    }
    
    public static func call911(success: @escaping(() -> Void), failure: @escaping(()-> Void)) {
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            if (status == INTULocationStatus.success) {
                let myLocation = SKLocation(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, altitude: currentLocation?.altitude ?? 0.0, verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0, horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0)
                print("Current Location: \(myLocation.dictionary)")
                SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/incident/", method: .post, parameters: myLocation.dictionary, responseModel: SKMessage.self, token: SKUserDefaults.getCSRFToken()) { response in
                    guard let response = response else { return }
                    print("Success: \(response)")
                    success()
                } failure: { error in
                    guard let error = error else { return }
                    print("Failure: \(error)")
                    failure()
                }
            }
            else if (status == INTULocationStatus.timedOut) {
                
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
            }
        }
    }
    
    public static func callEMS() {
        SKService.apiCall(with: "https://jsonplaceholder.typicode.com/todos/1", responseModel: SKDataResponse.self) { response in
            guard let response = response else { return }
            print("Success: \(response)")
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
        }
    }
}

struct SKDataResponse: Decodable {
    let completed: Bool
    let id: Int
    let userId: Int
    let title: String
}
