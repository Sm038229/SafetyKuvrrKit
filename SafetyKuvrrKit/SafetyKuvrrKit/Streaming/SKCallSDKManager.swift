//
//  SKCallSDKManager.swift
//  SafetyKuvrr
//
//  Created by Sachchida Nand Mishra on 25/01/23.
//  Copyright © 2023 OPTiMO Information Technology. All rights reserved.
//

import Foundation
import AgoraRtcKit
import AVFoundation

enum SKCameraPosition: Int {
    case front
    case back
}

@objc protocol SKCallingFeatureDelegate {
    @objc optional func handleMute(_ mute: Bool)
    @objc optional func handlePause(_ pause: Bool)
    @objc optional func addUser(forUID uid: UInt)
    @objc optional func removeUser(forUID uid: UInt)
    @objc optional func removeAllUser()
    @objc optional func didAudioMuted(forUID uid: UInt, mute: Bool)
    @objc optional func didVideoMuted(forUID uid: UInt, mute: Bool)
}

class SKCallSDKManager: NSObject {
    static let shared = SKCallSDKManager()
    static let appUserString = "K_"
    weak var delegate: SKCallingFeatureDelegate? = nil
    var agoraEngine: AgoraRtcEngineKit!
    
    var userRole: AgoraClientRole = .broadcaster
    var appID: String = ""
    var channel: String = ""
    var token: String = ""
    var joined: Bool = false
    var isLocalUserPaused: Bool = false
    var isUserNameHidden: Bool = true
    var userInfoData: [String : SKCallUserInfo]? = [:]
    
    private override init() {
        super.init()
    }
    
    func setConfig(forCamera direction: SKCameraPosition) {
        let config = AgoraCameraCapturerConfiguration()
        if direction == .back {
            config.cameraDirection = .rear
        } else {
            config.cameraDirection = .front
        }
        let result = agoraEngine.setCameraCapturerConfiguration(config)
        print("Camera Position Result : \(result)")
    }
    
    func initializeAgoraEngine(withAppID appID: String?, token: String?, channel: String?, joinNeeded: Bool = true, video: Bool = false, audio: Bool = false, cameraDirection direction: SKCameraPosition = .front, watermark: Bool = false) {
        guard let apppID = appID, let channnel = channel, let tokenn = token else { return }
        self.appID = apppID
        self.channel = channnel
        self.token = tokenn
        print("Details : \(String(describing: appID)), \(String(describing: channel))")
        //
        userInfoData = [:]
        let config = AgoraRtcEngineConfig()
        config.appId = self.appID
        if agoraEngine != nil {
            agoraEngine.disableVideo()
            agoraEngine.stopPreview()
        }
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        //agoraEngine.registerLocalUserAccount("Sachin Mishra", appId: self.appID)
        setConfig(forCamera: direction)
        agoraEngine.enableVideo()
        agoraEngine.startPreview()
        setAgoraEngine(withVideo: video, audio: audio)
        if joinNeeded == true {
            joinChannel()
        }
    }
    
    func joinOrLeave() {
        if !joined {
            joinChannel()
        } else {
            leaveChannel()
        }
    }
    
    func resetAllData() {
        UIApplication.shared.isIdleTimerDisabled = false
        leaveChannel()
        UIDevice.current.setValue( UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        //
        DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
    }
    
    func setAgoraEngine(withVideo video: Bool, audio: Bool) {
        let paused = !video
        delegate?.handlePause?(paused)
        agoraEngine.muteLocalVideoStream(paused)
        //
        let muted = !audio
        delegate?.handleMute?(muted)
        agoraEngine.muteLocalAudioStream(muted)
        if audio == true {
            agoraEngine.enableAudio()
        } else {
            //agoraEngine.disableAudio()
        }
    }
    
    func setupVideoView(via uid: UInt, intoView userView: UIView? = nil) {
        let videoCanvas = AgoraRtcVideoCanvas()
        if (uid == 0 && isLocalUserPaused == true) || userView == nil {
            videoCanvas.view = UIView()
        } else {
            videoCanvas.view = userView
        }
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.mirrorMode = .disabled
        videoCanvas.view?.tag = Int(uid)
        if uid == 0 {
            agoraEngine.setupLocalVideo(videoCanvas)
        } else {
            agoraEngine.setupRemoteVideo(videoCanvas)
        }
    }
    
//    func switchVideoViews(forCell cell: SKCustomCallCollectionViewCell, localVideoView: UIView, localUID: UInt, remoteUID: UInt) {
//        setupVideoView(via: remoteUID, intoView: localVideoView)
//        setupVideoView(via: localUID, intoView: cell.userVideoCallView)
//        cell.userVideoCallImageView.tag = Int(localUID)
//    }
    
    func checkForPermissions() -> Bool {
        var hasPermissions = false
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: hasPermissions = true
        default: hasPermissions = requestCameraAccess()
        }
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: hasPermissions = true
        default: hasPermissions = requestAudioAccess()
        }
        return hasPermissions
    }
    
    func requestCameraAccess() -> Bool {
        var hasCameraPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            hasCameraPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasCameraPermission
    }
    
    func requestAudioAccess() -> Bool {
        var hasAudioPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
            hasAudioPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasAudioPermission
    }
    
    func joinChannel(withVideo video: Bool = true, forCalling: Bool = true) {
        if SKCallSDKManager.shared.agoraEngine == nil {
            return
        }
        if !self.checkForPermissions() {
            return
        }
        
        let option = AgoraRtcChannelMediaOptions()
        option.publishCameraTrack = video
        // Set the client role option as broadcaster or audience.
        if self.userRole == .broadcaster {
            option.clientRoleType = .broadcaster
            //setupLocalVideo(via: localUserID)
        } else {
            option.clientRoleType = .audience
        }
        
        // For a video call scenario, set the channel profile as communication.
        if forCalling == true {
            option.channelProfile = .communication
        } else {
            option.channelProfile = .liveBroadcasting
        }
        
        if joined {
            agoraEngine.renewToken(token)
        } else {
            let result = agoraEngine.joinChannel(
                byToken: self.token, channelId: self.channel, uid: 0, mediaOptions: option,
                joinSuccess: { (channel, uid, elapsed) in }
            )
            // Check if joining the channel was successful and set joined Bool accordingly
            if (result == 0) {
                joined = true
                //showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
            }
        }
    }
    
    func leaveChannel() {
        if SKCallSDKManager.shared.agoraEngine == nil {
            return
        }
        SKCallSDKManager.shared.isLocalUserPaused = false
        SKCallSDKManager.shared.agoraEngine.disableVideo()
        SKCallSDKManager.shared.agoraEngine.stopPreview()
        SKCallSDKManager.shared.setAgoraEngine(withVideo: false, audio: false)
        let result = SKCallSDKManager.shared.agoraEngine.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if (result == 0) {
            joined = false
            delegate?.removeAllUser?()
            resetAllData()
        }
    }
    
    func getUserInfo(byUID uid: UInt) -> AgoraUserInfo {
        var userInfo = agoraEngine.getUserInfo(byUid: uid, withError: .none)
        if userInfo == nil || userInfo?.userAccount == nil || userInfo?.uid == nil {
            userInfo = AgoraUserInfo()
            userInfo?.userAccount = "Unknown"
            userInfo?.uid = uid
        }
        if let userData = userInfo?.userAccount?.components(separatedBy: "_"), userData.count > 0 {
            if userInfo?.userAccount?.hasPrefix(SKCallSDKManager.appUserString) == true {
                userInfo?.userAccount = userData[1]
            } else {
                userInfo?.userAccount = "Unknown"
            }
        }
        return userInfo!
    }
}


extension SKCallSDKManager: AgoraRtcEngineDelegate {
    // Callback called when a new host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUserInfoUpdatedWithUserId uid: UInt, userInfo: AgoraUserInfo) {
        if var userData = userInfoData?[String(uid)] {
            userData.userName = userInfo.userAccount
            userInfoData?.updateValue(userData, forKey: String(uid))
        } else {
            userInfoData?[String(uid)] = SKCallUserInfo(uid: uid, userName: userInfo.userAccount)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        if let userData = userInfoData?[String(uid)] {
            userInfoData?.updateValue(userData, forKey: String(uid))
        } else {
            userInfoData?[String(uid)] = SKCallUserInfo(uid: uid)
        }
        delegate?.addUser?(forUID: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        if userInfoData?[String(uid)] != nil {
            userInfoData?.removeValue(forKey: String(uid))
        }
        delegate?.removeUser?(forUID: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        if var userData = userInfoData?[String(uid)] {
            userData.audioMute = muted
            userInfoData?.updateValue(userData, forKey: String(uid))
        }
        delegate?.didAudioMuted?(forUID: uid, mute: muted)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        if var userData = userInfoData?[String(uid)] {
            userData.videoOff = muted
            userInfoData?.updateValue(userData, forKey: String(uid))
        }
        delegate?.didVideoMuted?(forUID: uid, mute: muted)
    }
    
    // Handle the event triggered by {AGORA_BACKEND} when the token is about to expire
    func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        joinChannel()
        //showMessage(title: "Authentication", text: "Token renewed")
    }
}
