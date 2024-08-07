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
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var localVideoButton: UIButton!
    @IBOutlet weak var localCameraSwitchButton: UIButton!
    @IBOutlet weak var localSpeakerButton: UIButton!
    @IBOutlet weak var localMicButton: UIButton!
    //
    //private static var appID = "e4a7751e763944a38680592591398f44" // Test Server
    private static var appID = "e9c9b52fcad241bcb1655f58fc2c16d6" // Red5 Server
    private static var token = ""
    private static var channelName = "Kuvrr_Demo_8May"
    private static var isTwoWayLiveStream = false
    private static var isRemoteUserJoined = false
    var chatTimer: Timer? = nil {
        willSet {
            if newValue == nil {
                chatTimer?.invalidate()
                SKStreaming.eventResponse = nil
                SKStreaming.chatResponse = nil
                SKStreaming.chatResponse2 = nil
                SKStreaming.isEventExist = false
                UIApplication.shared.isIdleTimerDisabled = false
                SKLocationManager.stopLocationUpdates()
            }
        }
    }
    static var isEventExist = false
    var lastLocationSendDate: Date?
    static var chatResponse: SKEventChatResponse?
    static var chatResponse2: SKEventChatResponse?
    static var unreadChatCount: Int = 0
    var chatVC: SKChatViewController?
    
    private var muted = false {
        didSet {
            let imageName = muted ? "mute" : "unmute"
            localMicButton.setImage(UIImage.named(imageName), for: .normal)
        }
    }
    
    private var paused: Bool = false {
        didSet {
            let imageName = paused ? "video_off" : "video_on"
            localVideoButton.setImage(UIImage.named(imageName), for: .normal)
            SKCallSDKManager.shared.isLocalUserPaused = paused
        }
    }
    
    private var cameraSwitched: Bool = false {
        didSet {
            //let imageName = cameraSwitched ? "camera_selected" : "camera_normal"
            //localCameraSwitchButton.setImage(UIImage.named(imageName), for: .normal)
        }
    }
    
    private var speakerOn: Bool = true {
        didSet {
            let imageName = speakerOn ? "speaker_on" : "speaker_off"
            localSpeakerButton.setImage(UIImage.named(imageName), for: .normal)
            SKCallSDKManager.shared.agoraEngine.setEnableSpeakerphone(speakerOn)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        startCamera()
        sendLocation()
        getChats()
    }
    
    private func invalidateTimer() {
        chatTimer = nil
    }
    
    private func displayEndEventActions() {
        let alertActions = [
            "Yes, I am OK.",
            "Oh, I was just testing it!",
            "Please call me!",
            "Please send help!",
            "Let me type my message...",
            "Cancel (I don't want to close yet)!"
        ]
        //
        let eventReasons = [
            "Yes, I am OK.",
            "Oh, I was just testing it!",
            "Please call me!",
            "Please send help!",
            "Other"
        ]
        let actions: [SKAlertAction] = alertActions.enumerated().map { (index, action) in
            if index == 5 {
                return .cancel(action)
            } else {
                return .normal(action)
            }
        }
        UIApplication.shared.confirmationAlert(forTitle: nil, message: "You are closing the SOS Event! Are you Ok?", actions: actions) { [weak self] (index, action) in
            if index < 5 {
                if index == 4 {
                    self?.endEvent(forReason : eventReasons[index], andMessage: "Custom Message for Testing")
                } else {
                    self?.endEvent(forReason : eventReasons[index])
                }
            }
        }
    }
    
    private func endEvent(forReason reason: String, andMessage message: String? = nil) {
        SKServiceManager.eventMediaStop(forEventUUID: SKStreaming.eventResponse?.uuid ?? "", success: { [weak self] response in
            SKServiceManager.endEvent(forReason: reason, andMessage: message) { [weak self] response in
                self?.dismiss(animated: true, completion: {
                    SKStreaming.leave()
                    self?.invalidateTimer()
                })
            } failure: { error in
                
            }
        }, failure: { error in
            
        })
    }
    
    @IBAction func endAction(_ sender: UIButton) {
        displayEndEventActions()
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        SKStreamingManager.presentChatViewController(forData: SKStreaming.chatResponse)
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func localVideoButtonActio(_ sender: UIButton) {
        paused.toggle()
        SKCallSDKManager.shared.agoraEngine.muteLocalVideoStream(paused)
        SKCallSDKManager.shared.setupVideoView(via: 0, intoView: localStremingView)
    }
    
    @IBAction func localCameraSwitchButtonActio(_ sender: UIButton) {
        cameraSwitched.toggle()
        SKCallSDKManager.shared.agoraEngine.switchCamera()
    }
    
    @IBAction func localSpeakerButtonActio(_ sender: UIButton) {
        speakerOn.toggle()
    }
    
    @IBAction func localMicButtonActio(_ sender: UIButton) {
        muted.toggle()
        SKCallSDKManager.shared.agoraEngine.muteLocalAudioStream(muted)
    }
    
    @objc func startCamera() {
        SKStreaming.isEventExist = true
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
    
    private func getChats() {
        self.chatButton.isEnabled = false
        self.chatCountLabel.isHidden = true
        chatTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let lastMessge = SKStreaming.chatResponse?.results?.last?.lastMessage
            SKServiceManager.getEventChats(forEventUUID: SKStreaming.eventResponse?.uuid, lastMessage: lastMessge) { [weak self] response in
                SKStreaming.chatResponse = response
                self?.setupChats(forResponse: response)
            } failure: { error in
                
            }
        }
    }
    
    private func setupChats(forResponse response: SKEventChatResponse?) {
        if let count = response?.count, count > 0 {
            if chatButton.isEnabled == false {
                chatButton.isEnabled = true
                SKStreamingManager.presentChatViewController(forData: response)
            } else if let topVC = UIApplication.shared.topViewController, topVC.isKind(of: SKChatViewController.self) {
                SKStreamingManager.setChatData(response)
                SKStreaming.chatResponse2 = response
                SKStreaming.unreadChatCount = 0
                chatCountLabel.isHidden = true
            } else {
                SKStreaming.unreadChatCount = (response?.count ?? 0) - (SKStreaming.chatResponse2?.count ?? 0)
                if SKStreaming.unreadChatCount == 0 {
                    chatCountLabel.isHidden = true
                } else {
                    chatCountLabel.isHidden = false
                }
            }
            chatCountLabel.text = "\(SKStreaming.unreadChatCount)"
        }
    }
    
    private func sendLocation() {
        lastLocationSendDate = Date()
        SKLocationManager.startLocationUpdates { [weak self] currentLocation in
            if let lastDate = self?.lastLocationSendDate, lastDate.timeIntervalSinceNow <= -10 {
                print("sendLocation : \(lastDate.timeIntervalSinceNow)")
                SKServiceManager.sendEventLocation(currentLocation) { response in
                    self?.lastLocationSendDate = Date()
                } failure: { error in
                    
                }
            }
        } failure: { error in
            
        }
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
        SKCallSDKManager.shared.setupVideoView(via: uid, intoView: mute == true ? nil : remoteStreamingView)
    }
    
    func reloadCollectionView() {
        
    }
}
