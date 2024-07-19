//
//  SKERPManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import Foundation
import UIKit

struct SKERPManager {
    
    private static func viewController(identifier: String) -> UIViewController? {
        let vc = UIApplication.viewController(forStoryboardID: "ERP", viewControllerID: identifier)
        return vc
    }
    
    static func presentERPListViewController() {
        if let topController = UIApplication.topViewController(), let vc = SKERPManager.viewController(identifier: "SKERPListTableViewController") as? SKERPListTableViewController {
            vc.modalPresentationStyle = .fullScreen
            topController.present(vc, animated: true)
        }
    }
    
    static func presentSelectedERPListViewController() {
        if let topController = UIApplication.topViewController(), let vc = SKERPManager.viewController(identifier: "SKSelectedERPTableViewController") as? SKSelectedERPTableViewController {
            vc.modalPresentationStyle = .fullScreen
            topController.present(vc, animated: true)
        }
    }
}
