//
//  VerticalSliderViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import Foundation
import Combine

class VerticalSliderViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    init(state: TouchPadModel) {
        self.state = state
        self.updateSpeed()
        self.updateAltitude()
        self.updateFlaps()
        self.updateGear()
        self.updateSpoiler()
        
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    func setupSubscribers() {
        state.didSetAircraftData
            .sink {
                self.updateSpeed()
                self.updateAltitude()
                self.updateFlaps()
                self.updateGear()
                self.updateSpoiler()
        }
        .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published var speed: Int = 250
    @Published var altitude: Int = 10000
    @Published var flaps: Int = 0
    @Published var gear: Int = 0
    @Published var spoiler: Int = 0
    
    // MARK: Update functions to be called from state via combine
    func updateSpeed() {
        speed = state.aircraftData.speed
    }
    func updateAltitude() {
        altitude = state.aircraftData.altitude
    }
    func updateFlaps() {
        flaps = state.aircraftData.flaps
    }
    func updateGear() {
        gear = state.aircraftData.gear
    }
    func updateSpoiler() {
        spoiler = state.aircraftData.spoiler
    }
}
