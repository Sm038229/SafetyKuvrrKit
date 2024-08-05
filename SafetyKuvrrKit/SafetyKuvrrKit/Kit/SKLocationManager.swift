//
//  SKLocationManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 17/07/24.
//

import Foundation
import INTULocationManager

struct SKLocationManager {
    static var locationRequestID: INTULocationRequestID?
    static var locationUpdatesRequestID: INTULocationRequestID?
    
    private static func convertLocation(_ currentLocation: CLLocation?) -> SKLocation {
        let myLocation = SKLocation(
            latitude: currentLocation?.coordinate.latitude ?? 0.0,
            longitude: currentLocation?.coordinate.longitude ?? 0.0,
            altitude: currentLocation?.altitude ?? 0.0,
            verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0,
            horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0,
            course: currentLocation?.course ?? 0.0
        )
        return myLocation
    }
    
    static func currentLocation(success: @escaping((SKLocation) -> Void), failure: @escaping((String?)-> Void)) {
        SKPermission.requestLocation { status in
            if status == false {
                failure("Please Allow Location Permission...")
            } else {
                SKLocationManager.locationRequestID = INTULocationManager.sharedInstance().requestLocation(
                    withDesiredAccuracy: .city,
                    timeout: 10.0,
                    delayUntilAuthorized: true
                ) { (currentLocation, achievedAccuracy, status) in
                    if (status == INTULocationStatus.success) {
                        let myLocation = SKLocationManager.convertLocation(currentLocation)
                        success(myLocation)
                    }
                    else if (status == INTULocationStatus.timedOut) {
                        failure("Location Timeout...")
                    }
                    else {
                        failure("Location Failed...")
                    }
                    SKLocationManager.stopRequestedLocation()
                }
            }
        }
    }
    
    static func stopRequestedLocation() {
        if let requestID = SKLocationManager.locationRequestID {
            INTULocationManager.sharedInstance().cancelLocationRequest(requestID)
            SKLocationManager.locationRequestID = nil
        }
    }
    
    static func stopLocationUpdates() {
        if let requestID = SKLocationManager.locationUpdatesRequestID {
            INTULocationManager.sharedInstance().cancelLocationRequest(requestID)
            SKLocationManager.locationUpdatesRequestID = nil
        }
    }
    
    static func startLocationUpdates(success: @escaping((SKLocation) -> Void), failure: @escaping((String?)-> Void)) {
        INTULocationManager.sharedInstance().setBackgroundLocationUpdate(true)
        INTULocationManager.sharedInstance().setPausesLocationUpdatesAutomatically(false)
        SKLocationManager.locationUpdatesRequestID = INTULocationManager.sharedInstance().subscribeToLocationUpdates { currentLocation, accuracy, status in
            print("startLocationUpdates : \(status)")
            switch status {
            case .success:
                let myLocation = SKLocationManager.convertLocation(currentLocation)
                success(myLocation)
            default:
                failure("Error")
            }
        }
    }
}
