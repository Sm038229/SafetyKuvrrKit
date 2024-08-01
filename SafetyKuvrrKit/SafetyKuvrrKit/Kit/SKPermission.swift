//
//  SKPermission.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 04/07/24.
//

import Foundation
import PermissionKit

// MARK: - Permissions
struct SKPermission {
    private init() {}
}

// MARK: - Location Permission
extension SKPermission {
    static var isLocationAuthorized: Bool {
        return Provider.location(.alwaysAndWhenInUse).isAuthorized
    }
    //
    static func requestLocation(status : @escaping((Bool) -> Void)) {
        Provider.location(.alwaysAndWhenInUse).request { (result) in
            status(result)
        }
    }
}

// MARK: - Bluetooth Permission
extension SKPermission {
    static var isBluetoothAuthorized: Bool {
        return Provider.bluetooth.isAuthorized
    }
    //
    static func requestBluetooth(status : @escaping((Bool) -> Void)) {
        Provider.bluetooth.request { result in
            status(result)
        }
    }
}
