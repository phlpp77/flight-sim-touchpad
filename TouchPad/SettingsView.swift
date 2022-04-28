//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var appearanceVM: AppearanceViewModel
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    
    @State var speedText = ""
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $appearanceVM.showTapLocation) {
                        Text("Show coordinates")
                    }
                    Toggle(isOn: $appearanceVM.showTapIndicator) {
                        Text("Show indicator")
                    }
                }
                
                Section(header: Text("Web Socket"), footer: Text("Without a connection to the Web Socket server it is not possible to run this app satisfactory")) {
                    
                    
                    Button(action: {
                        socketNetworkVM.webSocketService.openWebSocket()
                    }) {
                        HStack {
                            Text("Server")
                            Spacer()
                            Text(socketNetworkVM.webSocketService.isConnectionOpen ? "Connected" : "Not connected")
                                .foregroundColor(.primary)
                        }
                    }
                
                    // MARK: Send string test
                    Button(action: {
                        socketNetworkVM.webSocketService.sendString("[Client] Hello from iOS Client!")
                    }) {
                        Text("Send hello to server")
                    }
                    
                    // MARK: - Flight simulator functions
                    
                    // MARK: Declare offsets
                    Button(action: {
                        socketNetworkVM.webSocketService.declareOffsets()
                    }) {
                        Text("Declare Offsets")
                    }
                    
                    // MARK: Change speed
                    TextField("Speed: ", text: $speedText)
                        .keyboardType(.numberPad)
                    Button(action: {
                        guard let speedNumber = Int(speedText) else {
                            print("Input is not a valid number")
                            return
                        }
                        socketNetworkVM.webSocketService.changeSpeed(speedNumber)
                    }) {
                        Text("Set speed to 222")
                    }
                }
            }
            .navigationTitle(Text("Settings"))
            .navigationViewStyle(.stack)
        }
        .accessibilityLabel("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let appearanceVM = AppearanceViewModel()
        let socketNetworkVM = SocketNetworkViewModel()
        SettingsView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
