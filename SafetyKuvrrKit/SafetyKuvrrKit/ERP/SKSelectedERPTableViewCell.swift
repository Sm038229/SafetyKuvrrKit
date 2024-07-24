//
//  SKSelectedERPTableViewCell.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import UIKit

class SKSelectedERPTableViewCell: UITableViewCell {
    static let identifier = "SKSelectedERPTableViewCell"
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var checkboxTapped: ((UIButton)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkboxAction(_ sender: UIButton) {
        checkboxTapped?(sender)
    }

}
