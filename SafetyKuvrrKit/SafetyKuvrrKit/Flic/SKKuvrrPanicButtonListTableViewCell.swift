//
//  SKKuvrrPanicButtonListTableViewCell.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 31/07/24.
//

import UIKit

class SKKuvrrPanicButtonListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var batteryStatusLabel: UILabel!
    @IBOutlet weak var unpairButtonView: UIView!
    @IBOutlet weak var unpairButton: UIButton!
    
    var kuvrrButton: SKKuvrrButton!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(button: SKKuvrrButton, atIndexPath indexPath: IndexPath) {
        self.kuvrrButton = button
        self.indexPath = indexPath
        self.nameLabel?.setupLabel(text: button.name)
        let batteryText1 = "Battery Status : "
        let batteryText2 = button.batteryStatus
        let attrStr1 = batteryText1.attributedStringWithColor([batteryText1], color: .lightGray)
        let attrStr12 = batteryText2.attributedStringWithColor([batteryText2], color: button.batteryStatusColor ?? .black)
        let combination = NSMutableAttributedString()
        combination.append(attrStr1)
        combination.append(attrStr12)
        self.batteryStatusLabel?.attributedText = combination
        self.batteryStatusLabel.font = UIFont.regularFontSmallSize()
    }

    @IBAction func unpairAction(_ sender: UIButton) {
        let alertActions = ["Cancel", "Unpair"]
        let actions = [
            SKAlertAction.cancel(value: alertActions[0]),
            SKAlertAction.destructive(value: alertActions[1])
        ]
        UIApplication.shared.confirmationAlert(forTitle: "Please confirm", message: "Are you sure you want to unpair this panic button ?", actions: actions) { [weak self] action in
            if let button = self?.kuvrrButton, action == alertActions[1] {
                SKKuvrrButtonHandler.forget(kuvrrButton: button) {
                    UIApplication.shared.topViewController?.navigationController?.popViewController(animated: true)
                } failure: {
                    
                }
            }
        }
    }
}
