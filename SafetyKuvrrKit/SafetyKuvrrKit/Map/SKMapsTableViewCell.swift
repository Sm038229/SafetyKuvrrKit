//
//  SKMapsTableViewCell.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import UIKit

class SKMapsTableViewCell: UITableViewCell {
    static let identifier = "SKMapsTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .regularFontNormalSize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
