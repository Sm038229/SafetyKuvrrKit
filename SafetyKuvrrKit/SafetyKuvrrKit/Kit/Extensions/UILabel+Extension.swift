//
//  UILabel+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 23/07/24.
//

import Foundation
import UIKit

extension UILabel {
    func setupLabel(text textt: String?, andFont fontt: UIFont? = UIFont.regularFontNormalSize()) {
        numberOfLines = 0
        font = fontt
        text = textt
        sizeToFit()
    }
    
    static func heightForLabel(text:String?, font:UIFont? = UIFont.regularFontNormalSize(), width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, .greatestFiniteMagnitude))
        label.setupLabel(text: text)
        //
        var height = label.frame.height
        label.removeFromSuperview()
        if height < 50 { height = 50 }
        return height
    }
}

extension UIImage {
    static func named(_ name: String) -> UIImage? {
        if let bundlePath = Bundle(for: SKSelectedERPTableViewCell.self).resourcePath, let resourceBundle = Bundle(path: bundlePath) {
            return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
        } else {
            return nil
        }
    }
}
