//
//  SKStreaming.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 08/07/24.
//

import Foundation
import UIKit

public class SKStreaming: UIViewController {
    @IBOutlet weak var localStremingView: UIView!
    @IBOutlet weak var remoteStreamingView: UIView!
    //
    private var appID = "e4a7751e763944a38680592591398f44"
    private var token = ""
    private var channelName = "Kuvrr_Demo_8May"
    private var isTwoWayLiveStream = false
    private var isRemoteUserJoined = false
    
    public static func viewController() -> SKStreaming {
        let storyboard = UIStoryboard(name: "Streaming", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SKStreaming") as! SKStreaming
        return vc
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        startCamera()
    }
    
    @IBAction func endAction(_ sender: UIButton) {
        leave()
    }
    
    @objc func startCamera() {
        SKCallSDKManager.shared.delegate = self
        SKCallSDKManager.shared.initializeAgoraEngine(withAppID: appID, token: token, channel: channelName, joinNeeded: false, video: true, audio: true, cameraDirection: .front, watermark: true)
        SKCallSDKManager.shared.setupVideoView(via: 0, intoView: localStremingView)
        join()
    }
    
    func join() {
        //        if AppDelegate.instance().currentIncident?.isTwoWayLiveStream == false {
        //            SKCallSDKManager.shared.agoraEngine.setDualStreamMode(.disableSimulcastStream)
        //        }
        SKCallSDKManager.shared.joinChannel(withVideo: true, forCalling: false)
    }
    
    func leave() {
        SKCallSDKManager.shared.leaveChannel()
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
    }
    
    func removeUser(forUID uid: UInt) {
        
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
