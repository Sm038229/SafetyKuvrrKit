//
//  UIViewController+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 23/07/24.
//

import Foundation
import UIKit

extension UIViewController {
    func addBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(actionDismiss(sender:)))
    }
    
    @objc private func actionDismiss(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
