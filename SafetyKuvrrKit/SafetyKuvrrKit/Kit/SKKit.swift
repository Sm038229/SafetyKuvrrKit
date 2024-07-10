//
//  SKKit.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 08/07/24.
//

import Foundation

public protocol SKKit {
    static var isUserLoggedIn: Bool { get }
    static func initialize()
    static func login(withMoble mobile: String, country: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void))
    static func login(withEmail email: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void))
    static func verifyOTP(mobile: String, country: String, otp: String, success: @escaping(() -> Void), failure: @escaping((String?)-> Void))
    static func resendOTP(forMoble mobile: String, country: String, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void))
    static func raiseEvent(isSoS: Bool, isWalkSafe: Bool, isTimer: Bool, isMedical: Bool, isCheckIn: Bool, isCheckOut: Bool, isEMS: Bool, emsNumber number: Int?, success: @escaping((String?) -> Void), failure: @escaping((String?)-> Void))
}
