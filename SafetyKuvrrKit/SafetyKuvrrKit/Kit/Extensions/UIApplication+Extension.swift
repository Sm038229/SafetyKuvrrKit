//
//  UIApplication+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 11/07/24.
//

import Foundation
import UIKit

enum SKAlertAction {
    case cancel(value: String?)
    case destructive(value: String?)
    case normal(value: String?)
}

extension UIApplication {
    var topViewController: UIViewController? {
        get {
            return UIApplication.topViewController()
        }
    }
    
    static func viewController(forStoryboardID storyboardID: String, viewControllerID: String) -> UIViewController {
        let storyboardName = storyboardID
        let storyboardBundle = Bundle(for: SKStreaming.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    private static func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        base?.navigationBarSetup(forViewController:base)
        return base
    }
    
    func confirmationAlert(forTitle title: String?, message: String?, actions:[SKAlertAction]?, completion: @escaping ((String?) -> (Void))) {
        let confirmationAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for (index, action) in actions.enumerated() {
                var actionStr: String?
                var alertStyle: UIAlertAction.Style = .default
                switch action {
                case .cancel(let str):
                    actionStr = str
                    alertStyle = .cancel
                case .destructive(let str):
                    actionStr = str
                    alertStyle = .destructive
                case .normal(let str):
                    actionStr = str
                    alertStyle = .default
                }
                let alertAction = UIAlertAction(title: actionStr, style: alertStyle, handler: { (actionn: UIAlertAction!) in
                    print("\(String(describing: actionn.accessibilityIdentifier))")
                    completion(actionn.accessibilityIdentifier)
                })
                alertAction.accessibilityIdentifier = actionStr
                confirmationAlert.addAction(alertAction)
            }
        }

        UIApplication.shared.topViewController?.present(confirmationAlert, animated: true, completion: nil)
    }
}
