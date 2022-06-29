//
//  RingSliderViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import Foundation
import Combine
import CoreGraphics

class RingSliderViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    init(state: TouchPadModel) {
        self.state = state
        self.updateHeading()
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetAircraftData
            .sink {
                self.setHeadingFromServer()
            }
            .store(in: &subscriptions)
        state.didSetHeading
            .sink {
                self.updateHeading()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var degrees: Double!
    @Published public var oldDegrees: Double = .zero
    @Published public var progress: CGFloat = .zero
    @Published public var oldProgress: CGFloat = .zero
    @Published public var startTrim: CGFloat = .zero
    @Published public var endTrim: CGFloat = .zero
    @Published public var startAngle: Double = .zero
    @Published public var changed: Int = 0
    
    // MARK: Functions/Vars to interact with the state
    /// Change the value of an aircraft data
    public func changeValue(to value: Int) {
        state.changeAircraftData(of: .heading, to: value)
    }
    
    // MARK: Update functions to be called from state via combine
    private func updateHeading() {
        degrees = state.aircraftData.heading
    }
    private func setHeadingFromServer() {
        degrees = state.aircraftData.heading
        progress = degrees / 360
        oldDegrees = .zero
        oldProgress = .zero
        startTrim = .zero
        endTrim = degrees / 360
        startAngle = .zero
        changed += 1
    }
}
