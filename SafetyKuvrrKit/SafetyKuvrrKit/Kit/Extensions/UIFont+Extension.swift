//
//  UIFont+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 23/07/24.
//

import Foundation
import UIKit

extension UIFont {
    private struct SKFont {
        struct Name {
            static let regular = "Helvetica"
        }
        //
        struct Size {
            static let normal = 16.0
        }
    }
    //
    static func regularFontNormalSize() -> UIFont? {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.normal)
    }
}
