//
//  SKMapManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation
import UIKit

struct SKMapManager {
    
    private static func viewController(identifier: String) -> UIViewController? {
        let vc = UIApplication.viewController(forStoryboardID: "MAPs", viewControllerID: identifier)
        return vc
    }
    
    static func presentMapListViewController() {
        if let topController = UIApplication.shared.topViewController, let vc = SKMapManager.viewController(identifier: "SKMapNavigationController") as? UINavigationController {
            vc.modalPresentationStyle = .fullScreen
            topController.present(vc, animated: true)
        }
    }
    
    static func presentMapsViewController(forMapData data: SKMapInfoResponse?) {
        if let topController = UIApplication.shared.topViewController, let vc = SKMapManager.viewController(identifier: "SKMapsViewController") as? SKMapsViewController {
            vc.mapData = data
            topController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
