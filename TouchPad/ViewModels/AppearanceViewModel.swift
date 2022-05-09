//
//  FlightDataViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

class AppearanceViewModel: ObservableObject {
    
    @Published private var model: TouchPadModel = TouchPadModel()
    
    var showTapLocation: Bool {
        get {
            model.settings.showTapLocation
        }
        set {
            let newState = newValue
            model.changeTapLocation(newState)
        }
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
    
    // Settings from Model read only
    var settings: TouchPadModel.TouchPadSettings {
        return model.settings
    }
}
