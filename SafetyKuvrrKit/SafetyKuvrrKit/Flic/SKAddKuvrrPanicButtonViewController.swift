//
//  SKAddKuvrrPanicButtonViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 30/07/24.
//

import UIKit

class SKAddKuvrrPanicButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton()
    }
    
    private func addButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(actionAdd(sender:)))
    }
    
    @objc private func actionAdd(sender: AnyObject) {
        SKKuvrrButtonHandler.startKuvrrPanicButtonScanning(success: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }, failure: {
            
        })
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
