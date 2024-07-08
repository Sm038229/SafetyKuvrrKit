//
//  UIDevice+Extension.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 04/07/24.
//

import Foundation
import UIKit
import DeviceGuru

extension UIDevice {
    private var deviceGuru: DeviceGuru? {
        return DeviceGuruImplementation()
    }
    
    var deviceModel: String? {
        if let path = Bundle(identifier: Bundle.main.bundleIdentifier ?? "") {
            return try? UIDevice.current.deviceGuru?.hardwareDescription()
        } else {
            return nil
        }
    }
    
    var deviceType: String  {
        let model = UIDevice.current.model
        if model.lowercased().contains("iPhone".lowercased()) {
            return "Phone"
        } else if model.lowercased().contains("iPad".lowercased()) {
            return "Tablet"
        } else if model.lowercased().contains("iPod".lowercased()) {
            return "iPod"
        } else if model.lowercased().contains("Simulator".lowercased()) {
            return "Simulator"
        } else {
            return ""
        }
    }
    
    var osType: String  {
        return UIDevice.current.systemName
    }
    
    var osVersion: String  {
        return UIDevice.current.systemVersion
    }
    
    private func getOSVersion(forIndex index: Int) -> String {
        let components = UIDevice.current.osVersion.components(separatedBy: ".")
        var version = "0"
        for (indexx, selectedVersion) in components.enumerated() {
            if indexx == index {
                version = selectedVersion
                return version
            }
        }
        return version
    }
    
    var osVersionMajor: String  {
        return getOSVersion(forIndex: 0)
    }
    
    var osVersionMinor: String  {
        return getOSVersion(forIndex: 1)
    }
    
    var osVersionPoint: String  {
        return getOSVersion(forIndex: 2)
    }
    
    var appVersionWithBuildNumber: String  {
        let appVersion = UIDevice.current.appVersion
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return "\(appVersion) (\(buildNumber))"
    }
    
    var appVersion: String  {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    private func getAppVersion(forIndex index: Int) -> String {
        let components = UIDevice.current.appVersion.components(separatedBy: ".")
        var version = "0"
        for (indexx, selectedVersion) in components.enumerated() {
            if indexx == index {
                version = selectedVersion
                return version
            }
        }
        return version
    }
    
    var appVersionMajor: String  {
        return getAppVersion(forIndex: 0)
    }
    
    var appVersionMinor: String  {
        return getAppVersion(forIndex: 1)
    }
    
    var appVersionPoint: String  {
        return getAppVersion(forIndex: 2)
    }
}
