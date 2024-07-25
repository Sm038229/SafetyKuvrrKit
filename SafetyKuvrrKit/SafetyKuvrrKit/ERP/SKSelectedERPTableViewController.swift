//
//  SKSelectedERPTableViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import UIKit
import ActiveLabel

class SKSelectedERPTableViewController: UITableViewController {
    var selectedERPTitle = ""
    var selectedERPUUID = ""
    var selectedERPCount = 0
    var erpDetail: SKERPListResponse?
    @IBOutlet weak var headerLabel: ActiveLabel!
    @IBOutlet weak var footerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedERPTitle
        //
        footerButton.titleLabel?.font = .boldFontNormalSize()
        //
        ActiveLabel.setupTapable(label: headerLabel)
        headerLabel.font = .boldFontNormalSize()
        headerLabel.text = "If this is a life threatening situation, please call 911."
        //
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView?.isHidden = true
        SKServiceManager.erpSelection(forUUID: selectedERPUUID) { [weak self] response in
            self?.erpDetail = response
            self?.tableView.reloadData()
        } failure: { error in
            
        }
    }
    @IBAction func ackAction(_ sender: UIButton) {
        if let version = erpDetail?.version, let uuid = erpDetail?.uuid {
            SKServiceManager.erpAcknowledgement(forVersion: version, andUUID: uuid) { [weak self] response in
                self?.navigationController?.popViewController(animated: true)
            } failure: { error in
                
            }
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
        return erpDetail?.jsonData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SKSelectedERPTableViewCell.identifier, for: indexPath) as! SKSelectedERPTableViewCell
        
        if let data = erpDetail?.jsonData {
            cell.configure(forData: data, date: erpDetail?.acknowledgeMentDate, indexPath: indexPath)
        }
        
        cell.checkboxTapped = { [weak self] sender in
            self?.checkboxTapped(atIndexPath: IndexPath(row: sender.tag, section: 0))
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
    
    private func checkboxTapped(atIndexPath indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SKSelectedERPTableViewCell, erpDetail?.acknowledgeMentDate == nil {
            if cell.imgView.tag == 0 {
                cell.imgView.image = UIImage.named("toogle_on")
                cell.imgView.tag = 1
                selectedERPCount += 1
            } else {
                cell.imgView.image = UIImage.named("toogle_off")
                cell.imgView.tag = 0
                selectedERPCount -= 1
            }
            //
            if selectedERPCount == erpDetail?.jsonData?.count {
                tableView.tableFooterView?.isHidden = false
            } else {
                tableView.tableFooterView?.isHidden = true
            }
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
