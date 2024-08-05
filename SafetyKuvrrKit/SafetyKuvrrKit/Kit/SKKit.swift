//
//  SKKit.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 08/07/24.
//

import Foundation

public protocol SKKit {
    static var isUserLoggedIn: Bool { get }
    static func initialize()
    static func raiseSOS()
    static func raise911()
    static func getERPList()
    static func getMapList()
    static func getKuvrrPanicButtonList()
}
