//
//  SKKuvrrPanicButtonManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import Foundation
import UIKit

struct SKKuvrrPanicButtonManager {
    
    private static func viewController(identifier: String) -> UIViewController? {
        let vc = UIApplication.viewController(forStoryboardID: "KuvrrPanicButton", viewControllerID: identifier)
        return vc
    }
    
    static func presentKuvrrPanicButtonViewController() {
        if let topController = UIApplication.shared.topViewController, let vc = SKKuvrrPanicButtonManager.viewController(identifier: "SKKuvrrPanicButtonNavigationController") as? UINavigationController {
            topController.present(vc, animated: true)
        }
    }
    
    static func presentKuvrrPanicButtonListViewController() {
        if let topController = UIApplication.shared.topViewController, let vc = SKKuvrrPanicButtonManager.viewController(identifier: "SKKuvrrPanicButtonListTableViewController") as? SKKuvrrPanicButtonListTableViewController {
            topController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    static func presentAddKuvrrPanicButtonViewController() {
        if let topController = UIApplication.shared.topViewController, let vc = SKKuvrrPanicButtonManager.viewController(identifier: "SKAddKuvrrPanicButtonViewController") as? SKAddKuvrrPanicButtonViewController {
            topController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
