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
    @Published var showTapIndicator: Bool!
    @Published var speedStepsInFive: Bool!
    @Published var headingStepsInFive: Bool!
    @Published var screen: Screen!
    @Published var sliderSoundEffect: Bool!
    
    // MARK: Update functions to be called from state via combine
    func updateShowTapIndicator() {
        showTapIndicator = state.settings.showTapIndicator
    }
    func updateSpeedStepsInFive() {
        speedStepsInFive = state.settings.speedStepsInFive
    }
    func updateHeadingStepsInFive() {
        headingStepsInFive = state.settings.headingStepsInFive
    }
    func updateScreen() {
        screen = state.settings.screen
    }
    func updateSliderSoundEffect() {
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
