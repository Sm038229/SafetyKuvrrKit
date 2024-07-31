//
//  SKKuvrrPanicButtonTableViewCell.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 31/07/24.
//

import UIKit

class SKKuvrrPanicButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabelView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var chevronView: UIView!
    @IBOutlet weak var chevronImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(options: [String], atIndexPath indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.titleLabel?.setupLabel(text: options[indexPath.row])
            self.countLabel?.setupLabel(text: "\(SKKuvrrButtonHandler.getAllConnectedButtons().count)")
            self.chevronView.isHidden = true
            self.countLabelView.isHidden = false
        } else {
            self.titleLabel?.setupLabel(text: options[indexPath.row])
            self.chevronView.isHidden = false
            self.countLabelView.isHidden = true
        }
    }
}
