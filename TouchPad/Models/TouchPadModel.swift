//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation
import Combine

struct TouchPadModel {
    
    private(set) var settings = TouchPadSettings()
    private(set) var aircraftData = AircraftData()
    
    // Setup of MQTT service and combine
    let mqttService = MQTTNetworkService.shared
    let didSetAircraftData = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    mutating func setupSubscribers() {
        mqttService.didReceiveMessage
            .sink { message in
            print("message in model: \(message)")
        }
        .store(in: &subscriptions)
    }
    
    struct TouchPadSettings {
        var showTapIndicator: Bool = false
        var speedStepsInFive: Bool = true
        var headingStepsInFive: Bool = true
        var screen: Screen = .essential
        var sliderSoundEffect: Bool = true
        var webSocketConnectionIsOpen: Bool = false
    }
    
    struct AircraftData {
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
    
    mutating func changeSliderSoundEffect(_ newState: Bool) {
        settings.sliderSoundEffect = newState
    }
    
    mutating func changeAircraftData(of valueType: AircraftDataType, to value: Int) {
        switch valueType {
        case .speed:
            aircraftData.speed = value
        case .altitude:
            aircraftData.altitude = value
        case .heading:
            aircraftData.heading = Double(value)
        case .flaps:
            aircraftData.flaps = value
        case .gear:
            aircraftData.gear = value
        case .spoiler:
            aircraftData.spoiler = value
        }
    }
}
