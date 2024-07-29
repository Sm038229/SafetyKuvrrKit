//
//  SKStreaming.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 08/07/24.
//

import Foundation
import UIKit

final class SKStreaming: UIViewController {
    static var eventResponse: SKEventResponse?
    @IBOutlet weak var localStremingView: UIView!
    @IBOutlet weak var remoteStreamingView: UIView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    //
    //private static var appID = "e4a7751e763944a38680592591398f44" // Test Server
    private static var appID = "e9c9b52fcad241bcb1655f58fc2c16d6" // Red5 Server
    private static var token = ""
    private static var channelName = "Kuvrr_Demo_8May"
    private static var isTwoWayLiveStream = false
    private static var isRemoteUserJoined = false
    var chatTimer: Timer?
    static var chatResponse: SKEventChatResponse?
    var chatVC: SKChatTableViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCamera()
        getChats()
    }
    
    private func getChats() {
        self.chatButton.isEnabled = false
        chatTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            var lastMessge = SKStreaming.chatResponse?.results?.last?.lastMessage
            SKServiceManager.getEventChats(forEventUUID: SKStreaming.eventResponse?.uuid, lastMessage: lastMessge) { response in
                SKStreaming.chatResponse = response
                if let count = SKStreaming.chatResponse?.count, count > 0 {
                    if self?.chatButton.isEnabled == false {
                        self?.chatButton.isEnabled = true
                        SKStreamingManager.presentChatViewController(forData: SKStreaming.chatResponse)
                    } else {
                        SKStreamingManager.setChatData(response)
                    }
                }
            } failure: { error in
                
            }
        }
    }
    
    private func invalidateTimer() {
        chatTimer?.invalidate()
    }
    
    @IBAction func endAction(_ sender: UIButton) {
        SKServiceManager.eventMediaStop(forEventUUID: SKStreaming.eventResponse?.uuid ?? "", success: { [weak self] response in
            SKServiceManager.endEvent(forReason: "Other", andMessage: "Test Message") { response in
                self?.dismiss(animated: true, completion: {
                    SKStreaming.leave()
                    self?.invalidateTimer()
                })
            } failure: { error in
                
            }
        }, failure: { error in
            
        })
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        SKStreamingManager.presentChatViewController(forData: SKStreaming.chatResponse)
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        
    }
    
    @objc func startCamera() {
        let tokenn = SKStreaming.eventResponse?.streamToken ?? SKStreaming.token
        let channel = SKStreaming.eventResponse?.streamChannelName ?? SKStreaming.channelName
        SKCallSDKManager.shared.delegate = self
        DispatchQueue.main.async { [weak self] in
            SKCallSDKManager.shared.initializeAgoraEngine(withAppID: SKStreaming.appID, token: tokenn, channel: channel, joinNeeded: true, video: true, audio: true, cameraDirection: .front, watermark: true)
            SKCallSDKManager.shared.setupVideoView(via: 0, intoView: self?.localStremingView)
        }
    }
    
    static func join() {
        if SKStreaming.eventResponse?.isTwoWayLiveStream == false {
            SKCallSDKManager.shared.agoraEngine.setDualStreamMode(.disableSimulcastStream)
        }
        SKCallSDKManager.shared.joinChannel(withVideo: true, forCalling: false)
    }
    
    static func leave() {
        SKCallSDKManager.shared.resetAllData()
    }
    
    func switchCamera() {
        SKCallSDKManager.shared.agoraEngine.switchCamera()
    }
}

extension SKStreaming : SKCallingFeatureDelegate {
    func handlePause(_ pause: Bool) {
        
    }
    
    func handleMute(_ mute: Bool) {
        
    }
    
    func addUser(forUID uid: UInt) {
        SKCallSDKManager.shared.setupVideoView(via: uid, intoView: remoteStreamingView)
        remoteStreamingView.isHidden = false
    }
    
    func removeUser(forUID uid: UInt) {
        remoteStreamingView.isHidden = true
    }
    
    func removeAllUser() {
        
    }
    
    func didAudioMuted(forUID uid: UInt, mute: Bool) {
        
    }
    
    func didVideoMuted(forUID uid: UInt, mute: Bool) {
        //SKCallSDKManager.shared.setupVideoView(via: uid, intoView: mute == true ? nil : remoteView)
    }
    
    func reloadCollectionView() {
        
    }
}
