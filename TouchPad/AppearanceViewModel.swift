//
//  FlightDataViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

class AppearanceViewModel: ObservableObject {
    
    @Published private var model: TouchPadModel = TouchPadModel()
    
    // Settings from Model read only
    var settings: TouchPadModel.TouchPadSettings {
        return model.settings
    }
    
    
    func toggleTapLocation() {
        model.changeTapLocation(!settings.showTapLocation)
    }
}
