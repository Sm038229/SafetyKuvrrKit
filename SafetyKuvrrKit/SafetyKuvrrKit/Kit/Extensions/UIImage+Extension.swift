//
//  UIImage+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation
import UIKit

extension UIImage {
    static func named(_ name: String) -> UIImage? {
        if let bundlePath = Bundle(for: SKSelectedERPTableViewCell.self).resourcePath, let resourceBundle = Bundle(path: bundlePath) {
            return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
        } else {
            return nil
        }
    }
}
