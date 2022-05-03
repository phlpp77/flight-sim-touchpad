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
                
                HStack(spacing: 14) {
                    StatusField(
                        title: "Server",
                        status: (socketNetworkVM.webSocketService.isConnectionOpen ? "Connected" : "Not connected"),
                        statusIcon: socketNetworkVM.webSocketService.isConnectionOpen ? "externaldrive.fill.badge.checkmark" : "externaldrive.badge.xmark",
                        statusColor: socketNetworkVM.webSocketService.isConnectionOpen ? Color.green : Color.gray
                    )
                    
                    StatusField(
                        title: "Offsets",
                        status: "Not declared",
                        statusIcon: "questionmark.folder",
                        statusColor: Color.gray
                    )
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground)) // Change color from white to background
                .listRowInsets(EdgeInsets()) // remove insets so cards are inline with rest
                
                
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $appearanceVM.showTapLocation) {
                        Text("Show coordinates")
                    }
                    Toggle(isOn: $appearanceVM.showTapIndicator) {
                        Text("Show indicator")
                    }
                }
                
                
                Section(header: Text("Web Socket"), footer: Text("Without a connection to the Web Socket server it is not possible to run this app satisfactory")) {
                    
                    Toggle(isOn: $socketNetworkVM.toggleServerConnection) {
                        Text("Server")
                    }
                    
                    // MARK: Declare offsets
                    Button(action: {
                        socketNetworkVM.webSocketService.declareOffsets()
                    }) {
                        Text("Declare Offsets")
                            .foregroundColor(.blue)
                    }
                    
                    // MARK: Change speed
                    TextField("Speed", text: $speedText)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        guard let speedNumber = Int(speedText) else {
                            print("Input is not a valid number")
                            return
                        }
                        socketNetworkVM.webSocketService.changeSpeed(speedNumber)
                    }) {
                        Text("Set speed")
                            .foregroundColor(.blue)
                    }
                    
                    // MARK: Send string test
                    Button(action: {
                        socketNetworkVM.webSocketService.sendString("Hello from iOS Client!")
                    }) {
                        Text("Send test string to server")
                            .foregroundColor(.blue)
                    }
                    
                }
                
                Section(header: Text("Logfiles")) {
                    
                    // MARK: Create log file
                    Button {
                        createLogCSV(filename: "test-log")
                    } label: {
                        Text("Export Log as CSV")
                    }

                }
                
            }
            .foregroundColor(.primary)
            .navigationTitle(Text("Settings"))
            .navigationViewStyle(.stack)
        }
        .accessibilityLabel("Settings")
    }
    
    
    // MARK: StatusField at the top
    struct StatusField: View {
        let title: String
        var status: String
        var statusIcon: String
        var statusColor: Color
        
        var body: some View {
            
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Group {
                    Text("Status: \(status)")
                    Image(systemName: statusIcon)
                        .font(.largeTitle)
                        
                }
                .foregroundColor(statusColor)
                .padding(.top, 5)
                
            }
            .frame(width: 150, height: 150)
            .background(.white)
            .cornerRadius(20)
        }
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
