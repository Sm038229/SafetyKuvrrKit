//
//  SKStreamingManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 29/07/24.
//

import Foundation
import UIKit

struct SKStreamingManager {
    static var chatVC: SKChatViewController?
    static func viewController(identifier: String) -> UIViewController? {
        let vc = UIApplication.viewController(forStoryboardID: "Streaming", viewControllerID: identifier)
        return vc
    }
    
    static func presentViewController() {
        if let topController = UIApplication.shared.topViewController, let vc = SKStreamingManager.viewController(identifier: "SKStreaming") as? SKStreaming {
            topController.present(vc, animated: true)
        }
    }
    
    static func presentChatViewController(forData data: SKEventChatResponse?) {
        if let topController = UIApplication.shared.topViewController, let vc = SKStreamingManager.viewController(identifier: "SKChatViewController") as? SKChatViewController {
            SKStreamingManager.chatVC = vc
            vc.chatResponse = data
            topController.present(vc, animated: true)
        }
    }
    
    static func setChatData(_ data: SKEventChatResponse?) {
        SKStreamingManager.chatVC?.chatResponse = data
    }
}
