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
    static func requestLocation(status : @escaping((Bool) -> Void)) {
        Provider.location(.alwaysAndWhenInUse).request { (result) in
            print("isAuthorized: \(result)")
            status(result)
        }
    }
}

extension SKPermission {
    
}
