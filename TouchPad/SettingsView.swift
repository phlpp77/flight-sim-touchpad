//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var appearanceVM: AppearanceViewModel
    
    var webSocketService = SocketNetworkService()
    
    @State var showLocation: Bool = false
    @State var showTapIndicator: Bool = false
    
    var body: some View {
        
        VStack {
            Text("Settings")
                .font(.largeTitle)
            List {
//                Toggle(isOn: $showLocation) {
//                    Text("Show location in Button")
//                }
                Button(action: {
                    appearanceVM.toggleTapLocation()
                }) {
                    Text("Toggle Tap Location")
                }
                Toggle(isOn: $showTapIndicator) {
                    Text("Show Tap-indicator")
                }
                Button(action: {
                    webSocketService.openWebSocket()
                }) {
                    Text("Activate WebSocket connection")
                }
            }
        }
        .frame(width: 400, height: 400)
        
        
        
        .accessibilityLabel("Settings")
        
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let appearanceVM = AppearanceViewModel()
        SettingsView(appearanceVM: appearanceVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
