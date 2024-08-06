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
        let rightItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(actionAdd(sender:)))
        rightItem.setTitleTextAttributes([.foregroundColor : UIColor.white, .font: UIFont.regularFontXXXLargeSize()], for: .normal)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func actionAdd(sender: AnyObject) {
        SKPermission.requestBluetooth { [weak self] status in
            if status == true, SKPermission.isBluetoothAuthorized == true {
                self?.updateLabel(text: "Press and hold panic button for 7 seconds.", isPairing: true)
                SKKuvrrButtonHandler.startKuvrrPanicButtonScanning(success: { [weak self] message in
                    self?.updateLabel(text: message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }, failure: { [weak self] error in
                    self?.updateLabel(text: error)
                })
            } else {
                self?.updateLabel(text: "Please Turn On Bluetooth in your device.")
            }
        }
    }
    
    private func updateLabel(text: String?, isPairing: Bool = false) {
        textLabel.text = text
        navigationItem.leftBarButtonItem?.isEnabled = !isPairing
        navigationItem.rightBarButtonItem?.isEnabled = !isPairing
        navigationItem.hidesBackButton = isPairing
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
