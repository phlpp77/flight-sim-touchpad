//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

struct TouchPadModel {
    
    private(set) var settings = TouchPadSettings()
    private(set) var startValues = AircraftStartValues()
    
    struct TouchPadSettings {
        var showTapIndicator: Bool = false
        var speedStepsInFive: Bool = true
        var headingStepsInFive: Bool = true
        var screen: Screen = .essential
        var webSocketConnectionIsOpen: Bool = false
    }
    
    struct AircraftStartValues {
        var speed: Int = 250
        var heading: Double = 0
        var altitude: Int = 10000
        var flaps: Int = 0
        var gear: Int = 0
        var spoiler: Int = 0
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
    
    mutating func changeStartValues(of valueType: AircraftDataType, to value: Int) {
        switch valueType {
        case .speed:
            startValues.speed = value
        case .altitude:
            startValues.altitude = value
        case .heading:
            startValues.heading = Double(value)
        case .flaps:
            startValues.flaps = value
        case .gear:
            startValues.gear = value
        case .spoiler:
            startValues.spoiler = value
        }
    }
}
