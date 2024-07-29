//
//  SKChatTableViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 29/07/24.
//

import UIKit

class SKChatTableViewController: UITableViewController {
    var chatData: SKEventChatResponse?
    var chatResponse: SKEventChatResponse? {
        get {
            return chatData
        }
        set {
            if chatData?.count != newValue?.count {
                chatData = SKStreaming.chatResponse
                tableView.reloadData()
            } else {
                chatData = SKStreaming.chatResponse
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isClearBackground = true
    }
    
    @IBAction func endChatAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
 */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = chatData?.results?[indexPath.row]
        if let role = result?.authorRole, role.lowercased() == "Observer".lowercased() {
            let cell = tableView.dequeueReusableCell(withIdentifier: SKObserverChatTableViewCell.defaultIdentifier, for: indexPath) as! SKObserverChatTableViewCell

            cell.nameLabel.text = "\(result?.authorFirstName ?? "") \(result?.authorLastName ?? "")"
            cell.messageLabel.text = result?.message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SKUserChatTableViewCell.defaultIdentifier, for: indexPath) as! SKUserChatTableViewCell

            cell.nameLabel.text = "\(result?.authorFirstName ?? "") \(result?.authorLastName ?? "")"
            cell.messageLabel.text = result?.message
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
