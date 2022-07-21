//
//  StateContainer.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import Foundation

struct StateContainer {
    
    // MARK: State - single source of truth
    let state = TouchPadModel()
    
    // MARK: ViewModels
    let mqttNetworkVM: MQTTNetworkViewModel
    let socketNetworkVM = SocketNetworkViewModel()
    let userDefaultsVM = UserDefaultsViewModel()
    
    let appearanceVM: AppearanceViewModel
    let verticalSliderVM: VerticalSliderViewModel
    let ringSliderVM: RingSliderViewModel
    let atcMessagesVM: ATCMessagesViewModel
    let buttonsVM: ButtonsViewModel
    let stateValuesTestVM: StateValuesTestViewModel
    
    init() {
        mqttNetworkVM = MQTTNetworkViewModel(state: state)
        
        appearanceVM = AppearanceViewModel(state: state)
        verticalSliderVM = VerticalSliderViewModel(state: state)
        ringSliderVM = RingSliderViewModel(state: state)
        atcMessagesVM = ATCMessagesViewModel(state: state)
        buttonsVM = ButtonsViewModel(state: state, webSocket: socketNetworkVM, mqtt: mqttNetworkVM)
        stateValuesTestVM = StateValuesTestViewModel(state: state)
    }
}
