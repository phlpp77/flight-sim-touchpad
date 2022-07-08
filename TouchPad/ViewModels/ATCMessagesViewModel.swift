//
//  ATCMessagesViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.07.22.
//

import Foundation
import Combine
import AudioToolbox
import AVFoundation

class ATCMessagesViewModel: ObservableObject {
    
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
    @Published public var message: String!
    @Published public var animationTime: Double!
    
    // MARK: Functions/Vars to interact with the state
    // none
    
    // MARK: Update functions to be called from state via combine
    private func updateATCMessage() {
        message = state.serviceData.atcMessage
        animationTime = state.serviceData.showDuration
        SoundService.shared.atcSound()
        
        // Voice feedback
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: message)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
}
