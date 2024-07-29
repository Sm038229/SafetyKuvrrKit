//
//  SKStreamingManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 29/07/24.
//

import Foundation
import UIKit

struct SKStreamingManager {
    static var chatVC: SKChatTableViewController?
    static func viewController(identifier: String) -> UIViewController? {
        let vc = UIApplication.viewController(forStoryboardID: "Streaming", viewControllerID: identifier) as? UIViewController
        return vc
    }
    
    static func presentViewController() {
        if let topController = UIApplication.shared.topViewController, let vc = SKStreamingManager.viewController(identifier: "SKStreaming") as? SKStreaming {
            topController.present(vc, animated: true)
        }
    }
    
    static func presentChatViewController(forData data: SKEventChatResponse?) {
        if let topController = UIApplication.shared.topViewController, let vc = SKStreamingManager.viewController(identifier: "SKChatTableViewController") as? SKChatTableViewController {
            SKStreamingManager.chatVC = vc
            vc.chatResponse = data
            topController.present(vc, animated: true)
        }
    }
    
    static func setChatData(_ data: SKEventChatResponse?) {
        SKStreamingManager.chatVC?.chatResponse = data
    }
}
