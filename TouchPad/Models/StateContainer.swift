//
//  StateContainer.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import Foundation

struct StateContainer {
    
    // State - single source of truth
    let state = TouchPadModel()
    
    // ViewModels
    let appearanceVM: AppearanceViewModel
    let verticalSliderVM: VerticalSliderViewModel
    let ringSliderVM = RingSliderViewModel()
    let socketNetworkVM = SocketNetworkViewModel()
    let mqttNetworkVM = MQTTNetworkViewModel()
    
    init() {
        appearanceVM = AppearanceViewModel(state: state)
        verticalSliderVM = VerticalSliderViewModel(state: state)
    }
}
