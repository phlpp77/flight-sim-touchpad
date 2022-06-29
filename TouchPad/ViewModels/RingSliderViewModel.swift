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
                self.updateHeading()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var degrees: Double!
    @Published public var progress: CGFloat!
    @Published public var changed: Int = 0
    
    // MARK: Update functions to be called from state via combine
    private func updateHeading() {
        degrees = state.aircraftData.heading
        progress = degrees / 360
        changed += 1
    }
}
