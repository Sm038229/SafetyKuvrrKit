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
            static let bold = "Helvetica-Bold"
        }
        //
        struct Size {
            static let small = 12.0
            static let medium = 14.0
            static let normal = 16.0
            static let large = 18.0
            static let xLarge = 20.0
            static let xxLarge = 22.0
            static let xxxLarge = 24.0
        }
    }
    //
    static func regularFontSmallSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.small)!
    }
    //
    static func regularFontMediumSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.medium)!
    }
    //
    static func regularFontNormalSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.normal)!
    }
    //
    static func regularFontLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.large)!
    }
    //
    static func regularFontXLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.xLarge)!
    }
    //
    static func regularFontXXLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.xxLarge)!
    }
    //
    static func regularFontXXXLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.regular, size: SKFont.Size.xxxLarge)!
    }
    //
    static func boldFontSmallSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.small)!
    }
    //
    static func boldFontMediumSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.medium)!
    }
    //
    static func boldFontNormalSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.normal)!
    }
    //
    static func boldFontLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.large)!
    }
    //
    static func boldFontXLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.xLarge)!
    }
    //
    static func boldFontXXLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.xxLarge)!
    }
    //
    static func boldFontXXXLargeSize() -> UIFont {
        return UIFont(name: SKFont.Name.bold, size: SKFont.Size.xxxLarge)!
    }
}
