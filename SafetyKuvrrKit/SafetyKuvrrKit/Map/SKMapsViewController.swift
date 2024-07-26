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
        if let myURLString = mapData?.mapURL?.addHTTPURLPrefix, myURLString.isEmpty == false, let url = URL(string: myURLString) {
            load(url: url)
        } else {
            print("Map not found")
            webView.isHidden = true
            noDataLabel.text = "Map not found"
        }
    }
    
    private func load(url: URL) {
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension SKMapsViewController: WKUIDelegate {

    /**
     * Force all popup windows to remain in the current WKWebView.
     * By default, WKWebView is blocking new windows from being created
     * ex <a href="link" target="_blank">text</a>.
     * This code catches those popup windows and displays them in the current WKWebView.
     */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        // open in current view
        webView.load(navigationAction.request)

        // don't return a new view to build a popup into (the default behavior).
        return nil;
    }
}
