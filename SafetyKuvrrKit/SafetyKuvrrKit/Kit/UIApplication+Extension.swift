//
//  UIApplication+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 11/07/24.
//

import Foundation
import UIKit

extension UIApplication {
    static func viewController(forStoryboardID storyboardID: String, viewControllerID: String) -> UIViewController {
        let storyboardName = storyboardID
        let storyboardBundle = Bundle(for: SKStreaming.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
        return vc
    }
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}
