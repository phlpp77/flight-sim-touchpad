//
//  ViewModelConnector.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 28.06.22.
//

import Foundation
import SwiftUI

struct ViewModelConnector: View {
    
//    @ObservedObject private var model: TouchPadModel
    
//    @StateObject private var appearanceVM: AppearanceViewModel
    @StateObject private var socketNetworkVM = SocketNetworkViewModel()
    @StateObject private var mqttNetworkVM = MQTTNetworkViewModel()
    
//    init(model: TouchPadModel) {
//        _appearanceVM = StateObject(wrappedValue: AppearanceViewModel(model: model))
//        self.model = model
//    }
    
    let container = StateContainer()
    
    var body: some View {
        
        MainView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM)
                .preferredColorScheme(.dark)
                .environmentObject(container.appearanceVM)
                .environmentObject(container.verticalSliderVM)
                .environmentObject(container.ringSliderVM)
        
    }
}
