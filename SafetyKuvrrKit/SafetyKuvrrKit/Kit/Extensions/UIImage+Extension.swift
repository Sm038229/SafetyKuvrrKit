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
        return UIImage(named: name, in: Bundle.defaultBundle, compatibleWith: nil)
    }
}

extension UIColor {
    static var appDefaultColor: UIColor? {
        return UIColor(named: "appDefaultColor", in: Bundle.defaultBundle, compatibleWith: nil)
    }
    //
    static var appTableViewColor: UIColor? {
        return UIColor(named: "appTableViewColor", in: Bundle.defaultBundle, compatibleWith: nil)
    }
}

extension Bundle {
    static var defaultBundle: Bundle? {
        if let bundlePath = Bundle(for: SKBundle.self).resourcePath, let resourceBundle = Bundle(path: bundlePath) {
            return resourceBundle
        }
        return nil
    }
}

final class SKBundle: NSObject {
    private override init() { }
}
