//
//  SKPermission.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 04/07/24.
//

import Foundation
import CoreLocation

struct SKPermission {
    private init() {}
    
    static var isLocationAuthorized: Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .denied:
            return false
        case .notDetermined:
            return false
        case .restricted:
            return false
        @unknown default:
            return false
        }
    }
    //
    static func requestLocation() {
//        Provider.location(.alwaysAndWhenInUse).request { (result) in
//            print("isAuthorized: \(result)")
        
        CLLocationManager().requestAlwaysAuthorization()
    }
}

extension SKPermission {
    
}
