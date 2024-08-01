//
//  SKKuvrrPanicButtonListTableViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import UIKit

class SKKuvrrPanicButtonListTableViewController: UITableViewController {
    var connectedButtons: [SKKuvrrButton]? = []
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Connected Button(s)"
        connectedButtons = SKKuvrrButtonHandler.getAllConnectedButtons()
        if connectedButtons?.count ?? 0 <= 0 {
            self.view.addNoDataLabel(text: "Currently there is no panic button paired.")
        }
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
        return connectedButtons?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SKKuvrrPanicButtonListTableViewCell.defaultIdentifier, for: indexPath) as! SKKuvrrPanicButtonListTableViewCell
        if let button = connectedButtons?[indexPath.row] {
            cell.configure(button: button, atIndexPath: indexPath)
        }
        
        return cell
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
