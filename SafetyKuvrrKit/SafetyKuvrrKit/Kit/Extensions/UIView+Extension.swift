//
//  UIView+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 29/07/24.
//

import Foundation
import UIKit

@IBDesignable
public extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    //
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor
            {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

@IBDesignable
public extension UIButton {
    @IBInspectable
    var padding: CGFloat {
        get {
            return titleEdgeInsets.top
        }
        set {
            if #available(iOS 15.0, *) {
                var configuration = self.configuration
                configuration?.contentInsets = NSDirectionalEdgeInsets(top: newValue, leading: newValue, bottom: newValue, trailing: newValue)
                self.configuration = configuration
            } else {
                titleEdgeInsets = UIEdgeInsets(top: newValue,left: newValue,bottom: newValue,right: newValue)
                contentEdgeInsets = titleEdgeInsets
            }
        }
    }
}
