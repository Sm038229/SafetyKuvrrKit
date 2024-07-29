//
//  SKSelectedERPTableViewCell.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import UIKit
import ActiveLabel

class SKSelectedERPTableViewCell: UITableViewCell {
    @IBOutlet weak var imgOuterView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var titleLabel: ActiveLabel!
    
    var checkboxTapped: ((UIButton)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(forData data: [String], date: String?, indexPath: IndexPath) {
        ActiveLabel.setupTapable(label: titleLabel)
        if date == nil {
            imgOuterView.isHidden = false
            imgView.image = UIImage.named("toogle_off")
        } else {
            imgOuterView.isHidden = true
        }
        titleLabel.setupLabel(text: data[indexPath.row])
        //titleLabel.text = data[indexPath.row]
        checkboxButton.tag = indexPath.row
    }
    
    @IBAction func checkboxAction(_ sender: UIButton) {
        checkboxTapped?(sender)
    }
}
