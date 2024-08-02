//
//  UIApplication+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 11/07/24.
//

import Foundation
import UIKit

enum SKAlertAction {
    case cancel(String)
    case destructive(String)
    case normal(String)
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
    
    func confirmationAlert(forTitle title: String?, message: String?, actions:[SKAlertAction]?, completion: @escaping ((Int, String) -> (Void))) {
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
                    if let actionString = actionn.accessibilityIdentifier,
                       let actionIndex = Int(actionn.accessibilityLabel ?? "0") {
                        completion(actionIndex, actionString)
                    }
                })
                alertAction.accessibilityIdentifier = actionStr
                alertAction.accessibilityLabel = "\(index)"
                confirmationAlert.addAction(alertAction)
            }
        }

        UIApplication.shared.topViewController?.present(confirmationAlert, animated: true, completion: nil)
    }
}

import UIKit

protocol KeyboardNotificationsDelegate: AnyObject {
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
    func keyboardDidShow(notification: NSNotification)
    func keyboardDidHide(notification: NSNotification)
}

extension KeyboardNotificationsDelegate {
    func keyboardWillShow(notification: NSNotification) {}
    func keyboardWillHide(notification: NSNotification) {}
    func keyboardDidShow(notification: NSNotification) {}
    func keyboardDidHide(notification: NSNotification) {}
}

class KeyboardNotifications {
    var keyBoardFrame: ((CGRect, Bool) -> Void) = {keyBoardFrame, status in}
    fileprivate var _isEnabled: Bool
    fileprivate var notifications: [KeyboardNotificationsType]
    fileprivate weak var delegate: KeyboardNotificationsDelegate?

    static func shared(withDelegate delegate:KeyboardNotificationsDelegate) -> KeyboardNotifications {
        return KeyboardNotifications(notifications: [.willShow, .willHide, .didShow, .didHide], delegate: delegate)
    }
    
    init(notifications: [KeyboardNotificationsType], delegate: KeyboardNotificationsDelegate) {
        _isEnabled = false
        self.notifications = notifications
        self.delegate = delegate
    }

    deinit { if isEnabled { isEnabled = false } }
}

// MARK: - enums

extension KeyboardNotifications {

    enum KeyboardNotificationsType {
        case willShow, willHide, didShow, didHide

        var selector: Selector {
            switch self {
                case .willShow: return #selector(keyboardWillShow(notification:))
                case .willHide: return #selector(keyboardWillHide(notification:))
                case .didShow: return #selector(keyboardDidShow(notification:))
                case .didHide: return #selector(keyboardDidHide(notification:))
            }
        }

        var notificationName: NSNotification.Name {
            switch self {
                case .willShow: return UIResponder.keyboardWillShowNotification
                case .willHide: return UIResponder.keyboardWillHideNotification
                case .didShow: return UIResponder.keyboardDidShowNotification
                case .didHide: return UIResponder.keyboardDidHideNotification
            }
        }
    }
}

// MARK: - isEnabled

extension KeyboardNotifications {

    private func addObserver(type: KeyboardNotificationsType) {
        NotificationCenter.default.addObserver(self, selector: type.selector, name: type.notificationName, object: nil)
    }

    var isEnabled: Bool {
        set {
            if newValue {
                for notificaton in notifications { addObserver(type: notificaton) }
            } else {
                NotificationCenter.default.removeObserver(self)
            }
            _isEnabled = newValue
        }

        get { return _isEnabled }
    }

}

// MARK: - Notification functions

extension KeyboardNotifications {

    @objc func keyboardWillShow(notification: NSNotification) {
        delegate?.keyboardWillShow(notification: notification)
        setKeyBoardFrame(forNotification: notification, isKeyboardShowing: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        delegate?.keyboardWillHide(notification: notification)
        setKeyBoardFrame(forNotification: notification, isKeyboardShowing: false)
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        delegate?.keyboardDidShow(notification: notification)
        setKeyBoardFrame(forNotification: notification, isKeyboardShowing: true)
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        delegate?.keyboardDidHide(notification: notification)
        setKeyBoardFrame(forNotification: notification, isKeyboardShowing: false)
    }
    
    private func setKeyBoardFrame(forNotification notification: NSNotification, isKeyboardShowing: Bool) {
        guard   let userInfo = notification.userInfo as? [String: NSObject],
                var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyBoardFrame(keyboardFrame, isKeyboardShowing)
    }
}
