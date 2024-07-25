//
//  SKMapsViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import UIKit
import WebKit

class SKMapsViewController: UIViewController {
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var mapData: SKMapInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.font = .regularFontNormalSize()
        if let myURLString = mapData?.mapURL, myURLString.isEmpty == false {
            var webURL = myURLString
            if webURL.hasPrefix("http://") == false {
                webURL = "http://" + webURL
            }
            if let url = URL(string: webURL) {
                load(url: url)
            }
        } else {
            print("URL not found")
            webView.isHidden = true
            noDataLabel.text = "URL not found"
        }
    }
    
    private func load(url: URL) {
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
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

extension SKMapsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
