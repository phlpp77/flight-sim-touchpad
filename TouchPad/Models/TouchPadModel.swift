//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

struct TouchPadModel {
    
    private(set) var settings = TouchPadSettings()
    
    struct TouchPadSettings {
//        var showTapLocation: Bool = false
        var showTapIndicator: Bool = false
        var speedStepsInFive: Bool = true
        var headingStepsInFive: Bool = true
        var webSocketConnectionIsOpen: Bool = false
    }
    
//    mutating func changeTapLocation(_ newState: Bool) {
//        settings.showTapLocation = newState
//    }
    
    mutating func changeTapIndicator(_ newState: Bool) {
        settings.showTapIndicator = newState
    }
    
    mutating func changeSpeedStepsInFive(_ newState: Bool) {
        settings.speedStepsInFive = newState
    }
    
    mutating func changeHeadingStepsInFive(_ newState: Bool) {
        settings.headingStepsInFive = newState
    }
   
    // TODO: Function not in use
//    mutating func changeWebSocketConnectionStatus (to newState: Bool) {
//        settings.webSocketConnectionIsOpen = newState
//        print("changed socket status: \(settings)")
//    }
    
}
