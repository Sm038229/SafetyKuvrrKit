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
    
//    static func topViewController() -> UIViewController? {
//        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            return topController
//        } else {
//            return nil
//        }
//    }
    
    static func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UIViewController {
    func addBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(actionDismiss(sender:)))
    }
    
    @objc private func actionDismiss(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UILabel {
    func setupLabel(text textt: String?, andFont fontt: UIFont? = UIFont(name: "Helvetica", size: 16.0)) {
        numberOfLines = 0
        font = fontt
        text = textt
        sizeToFit()
    }
    
    static func heightForLabel(text:String?, font:UIFont? = UIFont(name: "Helvetica", size: 16.0), width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, .greatestFiniteMagnitude))
        label.setupLabel(text: text)
        //
        var height = label.frame.height
        label.removeFromSuperview()
        if height < 50 { height = 50 }
        return height
    }
}
