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
        var showTapIndicator: Bool = false
        var speedStepsInFive: Bool = true
        var headingStepsInFive: Bool = true
        var screen: Screen = .essential
        var webSocketConnectionIsOpen: Bool = false
    }
    
    mutating func changeTapIndicator(_ newState: Bool) {
        settings.showTapIndicator = newState
    }
    
    mutating func changeSpeedStepsInFive(_ newState: Bool) {
        settings.speedStepsInFive = newState
    }
    
    mutating func changeHeadingStepsInFive(_ newState: Bool) {
        settings.headingStepsInFive = newState
    }
    
    mutating func changeScreen(_ newState: Screen) {
        settings.screen = newState
    }
    
}
