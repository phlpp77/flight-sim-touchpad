//
//  FlightDataViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation
import SwiftUI

class AppearanceViewModel: ObservableObject {
    
    var model: TouchPadModel
    
    init(model: TouchPadModel) {
        self.model = model
    }
    
    var showTapIndicator: Bool {
        get {
            model.settings.showTapIndicator
        }
        set {
            let newState = newValue
            model.changeTapIndicator(newState)
        }
    }
    
    var speedStepsInFive: Bool {
        get {
            model.settings.speedStepsInFive
        }
        set {
            let newState = newValue
            model.changeSpeedStepsInFive(newState)
        }
    }
    
    var headingStepsInFive: Bool {
        get {
            model.settings.headingStepsInFive
        }
        set {
            let newState = newValue
            model.changeHeadingStepsInFive(newState)
        }
    }
    
    var screen: Screen {
        get {
            model.settings.screen
        }
        set {
            let newState = newValue
            model.changeScreen(newState)
        }
    }
    
    var sliderSoundEffect: Bool {
        get {
            model.settings.sliderSoundEffect
        }
        set {
            let newState = newValue
            model.changeSliderSoundEffect(newState)
        }
    }
    
    // Settings from Model read only
    var settings: TouchPadModel.TouchPadSettings {
        return model.settings
    }
}
