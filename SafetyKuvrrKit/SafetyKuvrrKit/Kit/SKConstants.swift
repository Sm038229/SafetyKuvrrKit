//
//  SKConstants.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 03/07/24.
//

import Foundation

struct SKConstants {
    struct API {
        static let sessionInit = "session_init/"
        static let userDevice = "user_device/"
        static let login = "otp/login/"
        static let otpVerify = "otp/verify/"
        static let otpResend = "otp/resend/"
        static let incident = "incident/"
        static let incidentLocation = "incident_location/"
        static let incidentMediaStart = "media_incident/start/"
        static let incidentMediaStop = "incident_media/stop"
        static let erp = "erp/"
        static let map = "map/"
        static let chat = "incident_chat/"
        static let panicButtonPairUnpair = "panicbutton/regdereg/"
        static let panicButtonBatteryStatus = "panicbutton/alert/"
        static let panicButtonLogs = "panicbutton/log/"
    }
    //
    struct ResponderType {
        static let _911 = "911"
        static let _sos = "sos"
        static let _walk_safe = "safe_walk"
        static let _timer = "timer"
        static let _check_in = "check_in"
        static let _check_out = "check_out"
        static let _medical = "medical"
    }
}
