//
//  StateValuesTestViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import Foundation

class StateValuesTestViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    init(state: TouchPadModel) {
        self.state = state
        self.updateData()
    }
    
    // MARK: Vars that are used inside the view
    // Settings data
    @Published public var showTapIndicator: Bool!
    @Published public var speedStepsInFive: Bool!
    @Published public var headingStepsInFive: Bool!
    @Published public var screen: Screen = .essential
    @Published public var sliderSoundEffect: Bool!
    // Aircraft data
    @Published public var speed: Int!
    @Published public var altitude: Int!
    @Published public var flaps: Int!
    @Published public var gear: Int!
    @Published public var spoiler: Int!
    @Published public var heading: Double!
    
    func updateData() {
        showTapIndicator = state.settings.showTapIndicator
        speedStepsInFive = state.settings.speedStepsInFive
        headingStepsInFive = state.settings.headingStepsInFive
        screen = state.settings.screen
        sliderSoundEffect = state.settings.sliderSoundEffect
        
        speed = state.aircraftData.speed
        altitude = state.aircraftData.altitude
        flaps = state.aircraftData.flaps
        gear = state.aircraftData.gear
        spoiler = state.aircraftData.spoiler
        heading = state.aircraftData.heading
    }
}
