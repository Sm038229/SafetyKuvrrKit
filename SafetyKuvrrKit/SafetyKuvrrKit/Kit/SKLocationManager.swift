//
//  SKLocationManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 17/07/24.
//

import Foundation
import INTULocationManager

struct SKLocationManager {
    static func currentLocation(success: @escaping((SKLocation) -> Void), failure: @escaping((String?)-> Void)) {
        SKPermission.requestLocation { status in
            if status == false {
                failure("Please Allow Location Permission...")
            } else {
                INTULocationManager.sharedInstance().requestLocation(
                    withDesiredAccuracy: .city,
                    timeout: 10.0,
                    delayUntilAuthorized: true
                ) { (currentLocation, achievedAccuracy, status) in
                    if (status == INTULocationStatus.success) {
                        let myLocation = SKLocation(
                            latitude: currentLocation?.coordinate.latitude ?? 0.0,
                            longitude: currentLocation?.coordinate.longitude ?? 0.0,
                            altitude: currentLocation?.altitude ?? 0.0,
                            verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0,
                            horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0,
                            course: currentLocation?.course ?? 0.0,
                            directionDegrees: nil
                        )
                        success(myLocation)
                    }
                    else if (status == INTULocationStatus.timedOut) {
                        failure("Location Timeout...")
                    }
                    else {
                        failure("Location Failed...")
                    }
                }
            }
        }
    }
}
