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
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetAircraftData
            .sink {
                self.updateSpeed()
                self.updateAltitude()
                self.updateFlaps()
                self.updateGear()
                self.updateSpoiler()
            }
            .store(in: &subscriptions)
        state.didSetSpeed
            .sink {
                self.updateSpeed()
            }
            .store(in: &subscriptions)
        state.didSetAltitude
            .sink {
                self.updateAltitude()
            }
            .store(in: &subscriptions)
        state.didSetFlaps
            .sink {
                self.updateFlaps()
            }
            .store(in: &subscriptions)
        state.didSetGear
            .sink {
                self.updateGear()
            }
            .store(in: &subscriptions)
        state.didSetSpoiler
            .sink {
                self.updateSpoiler()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var speed: Int = 250
    @Published public var altitude: Int = 10000
    @Published public var flaps: Int = 0
    @Published public var gear: Int = 0
    @Published public var spoiler: Int = 0
    
    /// Change the value of an aircraft data
    public func changeValue(of type: AircraftDataType, to value: Int) {
        state.changeAircraftData(of: type, to: value)
    }
    
    // MARK: Update functions to be called from state via combine
    private func updateSpeed() {
        speed = state.aircraftData.speed
    }
    private func updateAltitude() {
        altitude = state.aircraftData.altitude
        print("altitude updaed")
    }
    private func updateFlaps() {
        flaps = state.aircraftData.flaps
    }
    private func updateGear() {
        gear = state.aircraftData.gear
    }
    private func updateSpoiler() {
        spoiler = state.aircraftData.spoiler
    }
}
