//
//  ViewModelConnector.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 28.06.22.
//

import Foundation
import SwiftUI

struct ViewModelConnector: View {
    
    @ObservedObject private var model: TouchPadModel
    
    @StateObject private var appearanceVM: AppearanceViewModel
    @StateObject private var socketNetworkVM = SocketNetworkViewModel()
    @StateObject private var mqttNetworkVM = MQTTNetworkViewModel()
    
    init(model: TouchPadModel) {
        _appearanceVM = StateObject(wrappedValue: AppearanceViewModel(model: model))
        self.model = model
    }
    
    var body: some View {
        
            MainView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM)
                .preferredColorScheme(.dark)
                .environmentObject(model)

        
    }
}
