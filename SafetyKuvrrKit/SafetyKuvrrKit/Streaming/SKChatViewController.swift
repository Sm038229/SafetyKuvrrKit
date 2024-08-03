//
//  SKChatTableViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 29/07/24.
//

import UIKit
import IQKeyboardManagerSwift

class SKChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var chatButtonsView: UIView!
    @IBOutlet weak var chatViewBottonConstraint: NSLayoutConstraint!
    
    var keyboardShared: KeyboardNotifications!
    var chatData: SKEventChatResponse?
    var chatResponse: SKEventChatResponse? {
        get {
            return chatData
        }
        set {
            if chatData?.count != newValue?.count {
                chatData = SKStreaming.chatResponse
                if tableView != nil {
                    tableView.reloadData()
                    tableView.scrollToBottom()
                }
            } else {
                chatData = SKStreaming.chatResponse
            }
        }
    }
    
    private func sendChat(message: String?) {
        if let message = message, message.isEmpty == false, let uuid = SKStreaming.eventResponse?.uuid {
            SKServiceManager.sendEventChats(forEventUUID: uuid, message: message) { [weak self] response in
                self?.chatTextField.text = nil
                self?.chatButtonsView.isHidden = false
            } failure: { error in
                
            }
        }
    }
    
    private func showKeyBoard() {
        keyboardShared = sharedKeyBoardNotifications()
        keyboardShared.isEnabled = true
        keyboardShared.keyBoardFrame = { [weak self] keyboardFrame, status in
            if status == true {
                self?.chatViewBottonConstraint.constant = keyboardFrame.height
                IQKeyboardManager.shared.enable = false
            } else {
                self?.chatViewBottonConstraint.constant = 0
                IQKeyboardManager.shared.enable = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isClearBackground = true
        //
        tableView.delegate = self
        tableView.dataSource = self
        //
        chatTextField.delegate = self
        chatTextField.becomeFirstResponder()
        //
        showKeyBoard()
    }
    
    @IBAction func endChatButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func yesChatAction(_ sender: UIButton) {
        sendChat(message: "Yes")
    }
    
    @IBAction func noChatAction(_ sender: UIButton) {
        sendChat(message: "No")
    }
    
    @IBAction func maybeChatAction(_ sender: UIButton) {
        sendChat(message: "Maybe")
    }
    
    @IBAction func unsureChatAction(_ sender: UIButton) {
        sendChat(message: "Unsure")
    }
}

extension SKChatViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = chatData?.results?[indexPath.row]
        let name = "\(result?.authorFirstName ?? "") \(result?.authorLastName ?? "")"
        let message = "\(result?.message ?? "")"
        if let role = result?.authorRole, role.lowercased() == "Observer".lowercased() {
            let cell = tableView.dequeueReusableCell(withIdentifier: SKObserverChatTableViewCell.defaultIdentifier, for: indexPath) as! SKObserverChatTableViewCell
            
            cell.nameLabel.setupLabel(text: name)
            cell.messageLabel.setupLabel(text: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SKUserChatTableViewCell.defaultIdentifier, for: indexPath) as! SKUserChatTableViewCell
            
            cell.nameLabel.setupLabel(text: name)
            cell.messageLabel.setupLabel(text: message)
            return cell
        }
    }
}

extension SKChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SKChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendChat(message: textField.text)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let count = textField.text?.count, count > 0 {
            chatButtonsView.isHidden = true
        } else {
            chatButtonsView.isHidden = false
        }
        return true
    }
}
