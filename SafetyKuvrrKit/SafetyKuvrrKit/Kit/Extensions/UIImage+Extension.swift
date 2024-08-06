//
//  UIImage+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation
import UIKit

final class SKBundle: NSObject {
    private override init() { }
}

extension Bundle {
    static var defaultBundle: Bundle? {
        if let bundlePath = Bundle(for: SKBundle.self).resourcePath, let resourceBundle = Bundle(path: bundlePath) {
            return resourceBundle
        }
        return nil
    }
}

extension UIImage {
    static func named(_ name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.defaultBundle, compatibleWith: nil)
    }
}

extension UIColor {
    static func named(_ name: String) -> UIColor? {
        return UIColor(named: name, in: Bundle.defaultBundle, compatibleWith: nil)
    }
}

extension UIColor {
    static var appDefaultColor: UIColor? {
        return UIColor.named("appDefaultColor")
    }
    //
    static var appTableViewColor: UIColor? {
        return UIColor.named("appTableViewColor")
    }
    //
    static var appBlueColor: UIColor? {
        return UIColor.named("appBlueColor")
    }
    //
    static var batteryStatusHigh: UIColor? {
        return UIColor.named("batteryHigh")
    }
    //
    static var batteryStatusLow: UIColor? {
        return UIColor.named("batteryLow")
    }
    //
    static var batteryStatusMedium: UIColor? {
        return UIColor.named("batteryMedium")
    }
    //
    static var batteryStatusUnknown: UIColor? {
        return UIColor.named("batteryUnknown")
    }
}
