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
    
    @objc func addToView(_ view: UIView, constant: NSNumber? = nil) {
        var myConstant = 0.0
        if let constant = constant {
            myConstant = CGFloat(truncating: constant)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        self.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: myConstant).isActive = true
        self.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: myConstant * -1).isActive = true
        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: myConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: myConstant * -1).isActive = true
    }
    
    @objc func addNoDataLabel(text: String? = nil) {
        let noDataLabel = UILabel(frame: .zero)
        noDataLabel.textAlignment = .center
        noDataLabel.text = text ?? "No data found"
        noDataLabel.font = UIFont.regularFontNormalSize()
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(noDataLabel)
        noDataLabel.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0).isActive = true
        noDataLabel.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0).isActive = true
        noDataLabel.addToView(self)
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
