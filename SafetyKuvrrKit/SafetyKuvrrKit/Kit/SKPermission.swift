//
//  SKPermission.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 04/07/24.
//

import Foundation
import PermissionKit

struct SKPermission {
    private init() {}
    
    static var isLocationAuthorized: Bool {
        return Provider.location(.alwaysAndWhenInUse).isAuthorized
    }
    //
    static var isBluetoothAuthorized: Bool {
        return Provider.bluetooth.isAuthorized
    }
    //
    static func isBluetoothOn(state : @escaping((Bool) -> Void)) {
        BluetoothState.powered { statee in
            switch statee {
            case .on:
                state(true)
            default:
                state(false)
            }
        }
    }
    //
    static func requestLocation(status : @escaping((Bool) -> Void)) {
        Provider.location(.alwaysAndWhenInUse).request { (result) in
            status(result)
        }
    }
    //
    static func requestBluetooth(status : @escaping((Bool) -> Void)) {
        Provider.bluetooth.request { result in
            status(result)
        }
    }
}

extension SKPermission {
    
}
