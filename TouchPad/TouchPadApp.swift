//
//  TouchPadApp.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.03.22.
//

import SwiftUI

@main
struct TouchPadApp: App {
    
    // Create container which holds the Model and pushes it to all ViewModels
    let container = StateContainer()
    
    var body: some Scene {
        WindowGroup {
            
            // Set the main theme and make all VMs available through out the app
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
