//
//  TouchPadApp.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.03.22.
//

import SwiftUI

@main
struct TouchPadApp: App {
    
    let container = StateContainer()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
                .environmentObject(container.appearanceVM)
                .environmentObject(container.verticalSliderVM)
                .environmentObject(container.ringSliderVM)
                .environmentObject(container.atcMessagesVM)
                .environmentObject(container.buttonsVM)
                .environmentObject(container.mqttNetworkVM)
                .environmentObject(container.socketNetworkVM)
                .environmentObject(container.stateValuesTestVM)
                .environmentObject(container.userDefaultsVM)
        }
    }
}
