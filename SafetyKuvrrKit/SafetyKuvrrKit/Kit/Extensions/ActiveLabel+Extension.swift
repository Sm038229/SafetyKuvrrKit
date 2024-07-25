//
//  ActiveLabel+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation
import ActiveLabel

extension ActiveType {
    struct SKRegexParser {
        static let numberPattern = "[0-9]*"
        static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    static var number: ActiveType {
        get {
            return ActiveType.custom(pattern: SKRegexParser.numberPattern)
        }
    }
    
    static var email: ActiveType {
        get {
            return ActiveType.custom(pattern: SKRegexParser.emailPattern)
        }
    }
}

extension ActiveLabel {
    static func setupTapable(label: ActiveLabel, types: [ActiveType] = [.mention, .hashtag, .url, .number, .email]) {
        label.enabledTypes = types
        //
        label.urlMaximumLength = 150
        label.textColor = .black
        label.font = .regularFontNormalSize()
        //
        label.handleMentionTap { element in
            //print("Mention type tapped: \(element)")
        }
        //
        label.handleHashtagTap { element in
            //print("Hashtag type tapped: \(element)")
        }
        //
        label.handleURLTap { element in
            //print("URL type tapped: \(element)")
            var url = element.absoluteString
            if url.hasPrefix("http://") == false {
                url = "http://" + url
            }
            if let exactURL = URL(string: url), UIApplication.shared.canOpenURL(exactURL) {
                UIApplication.shared.open(exactURL, options: [:]) { status in
                    print(status ? "URL Opened!" : "URL Failed!")
                }
            }
        }
        //
        label.customColor[.number] = UIColor.red
        label.customSelectedColor[.number] = UIColor.red
        label.handleCustomTap(for: .number) { element in
            //print("Number type tapped: \(element)")
            element.call()
        }
        //
        label.customColor[.email] = UIColor.link
        label.customSelectedColor[.email] = UIColor.link
        label.handleCustomTap(for: .email) { element in
            //print("Email type tapped: \(element)")
            SKMailManager.sendEmail(to: element) { result in
                print(result?.rawValue ?? "Unknown")
            }
        }
    }
}
