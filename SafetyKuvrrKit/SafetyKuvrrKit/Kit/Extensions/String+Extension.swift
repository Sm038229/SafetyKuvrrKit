//
//  String+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation
import UIKit

extension String {
    func call() {
        guard let url = URL(string: "telprompt://\(self)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var addHTTPURLPrefix: String? {
        if hasPrefix("http") == false {
            return "http://" + self
        } else {
            return self
        }
    }
    
    var getAllNumbers: [String]? {
        let numbersInString = self.components(separatedBy: .decimalDigits.inverted).filter { !$0.isEmpty }
        return numbersInString.compactMap { $0 }
    }
    
    var getAllLinks: [String]? {
        var urlsInString: [String]? = []
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            let url = self[range]
            urlsInString?.append(String(url))
        }
        return urlsInString
    }
    
    func attributedStringWithColor(_ colorizeWords: [String]?, color: UIColor = .link, characterSpacing: UInt? = nil, boldWords: [String]? = []) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        colorizeWords?.forEach { word in
            let range = (self as NSString).range(of: word)
            var myColor = color
            if let myInt = Int(word), myInt > 0 {
                if myInt == 911 {
                    myColor = .red
                }
                attributedString.addAttribute(.foregroundColor, value: myColor, range: range)
            } else {
                attributedString.addAttribute(.link, value: word, range: range)
            }
            
            if let isWordExist = boldWords?.contains(word), isWordExist == true {
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldFontNormalSize(), range: range)
            }
        }
        
        if let wordCount = boldWords?.count, wordCount > 0 {
            let range = (self as NSString).range(of: self)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldFontNormalSize(), range: range)
        }
        
        guard let characterSpacing = characterSpacing else {
            return attributedString
        }
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}
