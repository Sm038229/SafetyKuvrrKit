//
//  UIViewController+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 23/07/24.
//

import Foundation
import UIKit

extension UIViewController {
    var isClearBackground: Bool {
        get {
            if view.isOpaque == false, view.backgroundColor == UIColor.clear {
                return true
            } else {
                return false
            }
        }
        set {
            view.backgroundColor = UIColor.clear
            view.isOpaque = false
        }
    }
    
    func addBackButton(withTransparentBackground isClear: Bool = false) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(actionDismiss(sender:)))
        navigationBarSetup(forViewController:self)
    }
    
    @objc private func actionDismiss(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigationBarSetup(forViewController vc: UIViewController?, withColor color: UIColor? = .appDefaultColor, largeTitles: Bool = false) {
        // -----------------------------------------------------------
        // NAVIGATION BAR CUSTOMIZATION
        // -----------------------------------------------------------
        vc?.navigationController?.navigationBar.prefersLargeTitles = largeTitles
        vc?.navigationController?.navigationBar.tintColor = UIColor.white
        vc?.navigationController?.navigationBar.isTranslucent = false

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = color
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            vc?.navigationController?.navigationBar.standardAppearance = appearance
            vc?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            vc?.navigationController?.navigationBar.compactAppearance = appearance

        } else {
            vc?.navigationController?.navigationBar.barTintColor = color
            vc?.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            vc?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

        // -----------------------------------------------------------
        // NAVIGATION BAR SHADOW
        // -----------------------------------------------------------
        //vc?.navigationController?.navigationBar.layer.masksToBounds = false
        //vc?.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        //vc?.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        //vc?.navigationController?.navigationBar.layer.shadowRadius = 15
        //vc?.navigationController?.navigationBar.layer.shadowOpacity = 0.7
    }
}
