//
//  SKStreaming.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 08/07/24.
//

import Foundation
import UIKit

public class SKStreaming: UIViewController {
    static var eventResponse: SKEventResponse?
    @IBOutlet weak var localStremingView: UIView!
    @IBOutlet weak var remoteStreamingView: UIView!
    //
    //private static var appID = "e4a7751e763944a38680592591398f44" // Test Server
    private static var appID = "e9c9b52fcad241bcb1655f58fc2c16d6" // Red5 Server
    private static var token = ""
    private static var channelName = "Kuvrr_Demo_8May"
    private static var isTwoWayLiveStream = false
    private static var isRemoteUserJoined = false
    
    public static func viewController() -> SKStreaming {
        let vc = UIApplication.viewController(forStoryboardID: "Streaming", viewControllerID: "SKStreaming") as! SKStreaming
        return vc
    }
    
    public static func presentViewController() {
        if let topController = UIApplication.topViewController() {
            let vc = SKStreaming.viewController()
            vc.modalPresentationStyle = .fullScreen
            topController.present(vc, animated: true)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        startCamera()
    }
    
    @IBAction func endAction(_ sender: UIButton) {
        SKServiceManager.eventMediaStop(forEventUUID: SKStreaming.eventResponse?.uuid ?? "", success: { [weak self] response in
            SKServiceManager.endEvent(forReason: "Other", andMessage: "Test Message") { response in
                self?.dismiss(animated: true, completion: {
                    SKStreaming.leave()
                })
            } failure: { error in
                
            }
        }, failure: { error in
            
        })
    }
    
    @objc public func startCamera() {
        let tokenn = SKStreaming.eventResponse?.streamToken ?? SKStreaming.token
        let channel = SKStreaming.eventResponse?.streamChannelName ?? SKStreaming.channelName
        SKCallSDKManager.shared.delegate = self
        SKCallSDKManager.shared.initializeAgoraEngine(withAppID: SKStreaming.appID, token: tokenn, channel: channel, joinNeeded: true, video: true, audio: true, cameraDirection: .front, watermark: true)
        SKCallSDKManager.shared.setupVideoView(via: 0, intoView: localStremingView)
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
