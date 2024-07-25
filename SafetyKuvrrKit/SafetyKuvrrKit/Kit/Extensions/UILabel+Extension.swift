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
}
