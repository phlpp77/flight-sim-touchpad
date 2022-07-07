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
        self.updateAllData()
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetAircraftData
            .sink {
                self.updateAllData()
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
        state.didSetVerticalSpeed
            .sink {
                self.updateVerticalSpeed()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var speed: Int!
    @Published public var altitude: Int!
    @Published public var flaps: Int!
    @Published public var gear: Int!
    @Published public var spoiler: Int!
    @Published public var verticalSpeed: Int!
    
    // MARK: Functions/Vars to interact with the state
    /// Change the value of an aircraft data
    public func changeValue(of type: AircraftDataType, to value: Int) {
        state.changeAircraftData(of: type, to: value)
    }
    
    // MARK: Update functions to be called from state via combine
    private func updateAllData() {
        self.updateSpeed()
        self.updateAltitude()
        self.updateFlaps()
        self.updateGear()
        self.updateSpoiler()
        self.updateVerticalSpeed()
    }
    private func updateSpeed() {
        speed = state.aircraftData.speed
    }
    private func updateAltitude() {
        altitude = state.aircraftData.altitude
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
    private func updateVerticalSpeed() {
        verticalSpeed = state.aircraftData.verticalSpeed
    }
}
