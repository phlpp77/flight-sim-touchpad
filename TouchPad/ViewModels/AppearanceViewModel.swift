//
//  FlightDataViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation
import SwiftUI

class AppearanceViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    init(state: TouchPadModel) {
        self.state = state
        self.updateShowTapIndicator()
        self.updateSpeedStepsInFive()
        self.updateHeadingStepsInFive()
        self.updateScreen()
        self.updateSliderSoundEffect()
    }
    
    // MARK: Vars that are used inside the view
    @Published public var showTapIndicator: Bool!
    @Published public var speedStepsInFive: Bool!
    @Published public var headingStepsInFive: Bool!
    @Published public var screen: Screen = .essential
    @Published public var sliderSoundEffect: Bool!
    
    // MARK: Update functions to be called from state via combine
    private func updateShowTapIndicator() {
        showTapIndicator = state.settings.showTapIndicator
    }
    private func updateSpeedStepsInFive() {
        speedStepsInFive = state.settings.speedStepsInFive
    }
    private func updateHeadingStepsInFive() {
        headingStepsInFive = state.settings.headingStepsInFive
    }
    private func updateScreen() {
        screen = state.settings.screen
    }
    private func updateSliderSoundEffect() {
        sliderSoundEffect = state.settings.sliderSoundEffect
    }
    
    
    
//    init(model: TouchPadModel) {
//        self.model = model
//    }
    
//    var showTapIndicator: Bool {
//        get {
//            model?.settings.showTapIndicator
//        }
//        set {
//            let newState = newValue
//            model?.changeTapIndicator(newState)
//        }
//    }
//
//    var speedStepsInFive: Bool {
//        get {
//            model?.settings.speedStepsInFive
//        }
//        set {
//            let newState = newValue
//            model?.changeSpeedStepsInFive(newState)
//        }
//    }
//
//    var headingStepsInFive: Bool {
//        get {
//            model?.settings.headingStepsInFive
//        }
//        set {
//            let newState = newValue
//            model?.changeHeadingStepsInFive(newState)
//        }
//    }
//
//    var screen: Screen {
//        get {
//            model?.settings.screen
//        }
//        set {
//            let newState = newValue
//            model?.changeScreen(newState)
//        }
//    }
//
//    var sliderSoundEffect: Bool {
//        get {
//            model?.settings.sliderSoundEffect
//        }
//        set {
//            let newState = newValue
//            model?.changeSliderSoundEffect(newState)
//        }
//    }
    
    // Settings from Model read only
//    var settings: TouchPadModel.TouchPadSettings {
//        return model?.settings
//    }
    
}
