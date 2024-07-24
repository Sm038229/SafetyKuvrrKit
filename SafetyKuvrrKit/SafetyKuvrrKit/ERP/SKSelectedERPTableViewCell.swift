//
//  SKSelectedERPTableViewCell.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 19/07/24.
//

import UIKit
import ActiveLabel

class SKSelectedERPTableViewCell: UITableViewCell {
    static let identifier = "SKSelectedERPTableViewCell"
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
        setup()
        if date == nil {
            imgView.isHidden = false
            imgView.image = UIImage.named("toogle_off")
        } else {
            imgView.isHidden = true
        }
        titleLabel.setupLabel(text: data[indexPath.row])
        //titleLabel.text = data[indexPath.row]
        checkboxButton.tag = indexPath.row
    }
    
    @IBAction func checkboxAction(_ sender: UIButton) {
        checkboxTapped?(sender)
    }
    
    private func setup() {
        let numberRefEx = "[0-9]*"
        let number = ActiveType.custom(pattern: numberRefEx)
        //
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = ActiveType.custom(pattern: emailRegEx)
        //
        titleLabel.enabledTypes = [.mention, .hashtag, .url, number, email]
        //
        titleLabel.urlMaximumLength = 150
        titleLabel.textColor = .black
        //
        titleLabel.handleMentionTap { element in
            print("Mention type tapped: \(element)")
        }
        //
        titleLabel.handleHashtagTap { element in
            print("Hashtag type tapped: \(element)")
        }
        //
        titleLabel.handleURLTap { element in
            print("URL type tapped: \(element)")
            if UIApplication.shared.canOpenURL(element) {
                print("URL opening: \(element)")
                UIApplication.shared.open(element)
            }
        }
        //
        titleLabel.customColor[number] = UIColor.red
        titleLabel.customSelectedColor[number] = UIColor.red
        titleLabel.handleCustomTap(for: number) { element in
            print("Number type tapped: \(element)")
            element.call()
        }
        //
        titleLabel.customColor[email] = UIColor.link
        titleLabel.customSelectedColor[email] = UIColor.link
        titleLabel.handleCustomTap(for: email) { element in
            print("Email type tapped: \(element)")
            if let url = URL(string: element), UIApplication.shared.canOpenURL(url) {
                print("Email opening: \(element)")
                UIApplication.shared.open(url)
            }
        }
    }
}
