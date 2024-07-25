//
//  SKMailManager.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import Foundation
import MessageUI

final class SKMailManager: NSObject {
    private static let shared = SKMailManager()
    private static var mailResult: ((MFMailComposeResult?) -> Void)?
    
    private override init() { }
    
    static func sendEmail(to recipient: String, result: @escaping (MFMailComposeResult?) -> Void) {
        mailResult = result
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = SKMailManager.shared
            mail.setToRecipients([recipient])
            //mail.setSubject("Email Subject Here")
            //mail.setMessageBody("Message content.", isHTML: false)
            //mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            UIApplication.shared.topViewController?.present(mail, animated: true)
        } else {
            // show failure alert
            print("Mail is unable to compose!")
            SKMailManager.mailResult?(.failed)
        }
    }
}

extension SKMailManager: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            controller.dismiss(animated: true)
            SKMailManager.mailResult?(.sent)
        case .cancelled:
            controller.dismiss(animated: true)
            SKMailManager.mailResult?(.cancelled)
        case .failed:
            //print("Failed!")
            SKMailManager.mailResult?(.failed)
        case .saved:
            controller.dismiss(animated: true)
            SKMailManager.mailResult?(.saved)
        default:
            //print("Unknown!")
            SKMailManager.mailResult?(nil)
        }
    }
}
