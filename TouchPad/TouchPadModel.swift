//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

struct TouchPadModel {
    
    private(set) var settings = TouchPadSettings()
    
    struct TouchPadSettings {
        var showTapLocation: Bool = true
        var showTapIndicator: Bool = true
        var webSocketConnectionIsOpen: Bool = false
    }
    
    mutating func changeTapLocation(_ newState: Bool) {
        settings.showTapLocation = newState
    }
    
}
