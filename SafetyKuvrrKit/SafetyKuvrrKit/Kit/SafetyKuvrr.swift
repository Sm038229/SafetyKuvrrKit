//
//  SKTesting.swift
//  SafetyKuvrr
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation

public struct SafetyKuvrr: SKKit {
    private init() {}
    
    public static var isUserLoggedIn: Bool {
        get {
            return SKServiceManager.isUserLoggedIn
        }
    }
    
    public static func initialize() {
        SKServiceManager.initialize()
    }
    
    private static func login(withEmail email: String? = nil, withMoble mobile: String? = nil, country: String = "IN", success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
            SKServiceManager.login(withEmail: email, withMoble: mobile, country: country) { response in
                success(response)
            } failure: { error in
                failure(error)
            }
    }
    
    private static func verifyOTP(email: String? = nil, mobile: String? = nil, country: String = "IN", otp: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
            SKServiceManager.verifyOTP(email: email, mobile: mobile, otp: otp) { response in
                success(response)
            } failure: { error in
                failure(error)
            }
    }
    
    private static func resendOTP(forEmail email: String? = nil, forMoble mobile: String? = nil, country: String = "IN", success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
            SKServiceManager.resendOTP(forEmail: email, forMoble: mobile, country: country) { response in
                success(response)
            } failure: { error in
                failure(error)
            }
    }
    
    public static func raiseEvent(isSoS: Bool = false, isWalkSafe: Bool = false, isTimer: Bool = false, isMedical: Bool = false, isCheckIn: Bool = false, isCheckOut: Bool = false, isEMS: Bool = false, emsNumber number: Int? = nil, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void)) {
        SKServiceManager.raiseEvent(isSoS: isSoS, isWalkSafe: isWalkSafe, isTimer: isTimer, isMedical: isMedical, isCheckIn: isCheckIn, isCheckOut: isCheckOut, isEMS: isEMS, emsNumber: number, success: { response in
            success(response)
        }, failure: { error in
            failure(error)
        })
    }
    
    public static func presentERPListViewController() {
        SKERPManager.presentERPListViewController()
    }
    
    public static func presentMapListViewController() {
        SKMapManager.presentMapListViewController()
    }
}
