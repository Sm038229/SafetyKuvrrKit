//
//  SKERPListTableViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import UIKit
import SDWebImage

class SKERPListTableViewController: UITableViewController {
    var erpList: [SKERPListResponse?]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Emergency Response Plan"
        addBackButton()
        //
        tableView.estimatedRowHeight = 50
        SKServiceManager.erpList { [weak self] response in
            self?.erpList = response
            self?.tableView.reloadData()
        } failure: { error in
            
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
        return erpList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SKERPListTableViewCell.defaultIdentifier, for: indexPath) as! SKERPListTableViewCell

        if let data = erpList?[indexPath.row] {
            cell.imgView.sd_setImage(with: URL(string: data.iconURLString!))
            cell.titleLabel.setupLabel(text: data.title)
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
        if let data = erpList?[indexPath.row] {
            SKERPManager.presentSelectedERPListViewController(forTitle: data.title!, andUUID: data.uuid!)
        }
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
