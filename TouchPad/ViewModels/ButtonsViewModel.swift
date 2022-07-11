//
//  ButtonsViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 11.07.22.
//

import Foundation
import Combine

class ButtonsViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    init(state: TouchPadModel) {
        self.state = state
        self.updateATCMessage()
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetATCMessage
            .sink {
                self.updateATCMessage()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var zoomFactor: Int!
    
    // MARK: Functions/Vars to interact with the state
    // none
    
    // MARK: Update functions to be called from state via combine
    private func updateATCMessage() {
//        message = state.serviceData.atcMessage
        
    }
}
