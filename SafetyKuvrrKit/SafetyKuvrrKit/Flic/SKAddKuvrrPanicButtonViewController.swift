//
//  SKAddKuvrrPanicButtonViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import UIKit

class SKAddKuvrrPanicButtonViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pair"
        addButton()
    }
    
    private func addButton() {
        var rightItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(actionAdd(sender:)))
        rightItem.setTitleTextAttributes([.foregroundColor : UIColor.white, .font: UIFont.regularFontXXXLargeSize()], for: .normal)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func actionAdd(sender: AnyObject) {
        SKPermission.isBluetoothOn { state in
            SKPermission.requestBluetooth { [weak self] status in
                if state == true, status == true, SKPermission.isBluetoothAuthorized == true {
                    self?.navigationItem.leftBarButtonItem?.isEnabled = false
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                    self?.navigationItem.backBarButtonItem?.isEnabled = false
                    self?.textLabel.text = "Press and hold panic button for 7 seconds."
                    SKKuvrrButtonHandler.startKuvrrPanicButtonScanning(success: { [weak self] message in
                        self?.textLabel.text = message
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }, failure: { [weak self] error in
                        self?.textLabel.text = error
                        self?.navigationItem.leftBarButtonItem?.isEnabled = true
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                        self?.navigationItem.backBarButtonItem?.isEnabled = true
                    })
                } else {
                    self?.textLabel.text = "Please Turn On Bluetooth in your device."
                    self?.navigationItem.leftBarButtonItem?.isEnabled = true
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.navigationItem.backBarButtonItem?.isEnabled = true
                }
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
