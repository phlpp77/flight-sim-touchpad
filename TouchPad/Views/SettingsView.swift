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
    @State var fileName = ""
    @State var presentFileNameAlert = false
    @State var presentErrorAlert = false
    
    @State private var isPerformingTask = false
    
    var body: some View {
        
        NavigationView {
            Form {
                
                HStack(spacing: 14) {
                    StatusField(
                        title: "Server",
                        status: socketNetworkVM.connectionOpen ? "Connected" : "Not connected",
                        statusIcon: socketNetworkVM.connectionOpen ? "externaldrive.fill.badge.checkmark" : "externaldrive.badge.xmark",
                        statusColor: socketNetworkVM.connectionOpen ? Color.green : Color.gray
                    )
                    
                    StatusField(
                        title: "Offsets",
                        status: socketNetworkVM.offsetsDeclared ? "Declared" : "Not declared",
                        statusIcon: socketNetworkVM.offsetsDeclared ? "folder.fill" : "questionmark.folder",
                        statusColor: socketNetworkVM.offsetsDeclared ? Color.green : Color.gray
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
                        isPerformingTask = true
                                   
                                       Task {
                                           await socketNetworkVM.webSocketService.declareOffsets()
                                           isPerformingTask = false
                                       }
                        
                    }) {
                        ZStack {
                            Text("Declare Offsets")
                                .foregroundColor(.blue)
                            .opacity(isPerformingTask ? 0 : 1)

                                            if isPerformingTask {
                                                ProgressView()
                                            }
                                        }
                                    
                        
                    }
                    .disabled(isPerformingTask)

                    
                    // MARK: Change speed
                    HStack {
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
                    Button(action: {
                        presentFileNameAlert.toggle()
                    }) {
                        HStack {
                            Text("Export Log as CSV")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                    // Alert to get filename from user
                    .alert(
                        isPresented: $presentFileNameAlert,
                        TextAlert(
                            title: "Export log file",
                            message: "Name the file of the log",
                            placeholder: "Log-Testpilot-1",
                            accept: "Export",
                            cancel: "Cancel",
                            keyboardType: .namePhonePad
                        ) { result in
                            if var text = result {
                                if text == "" {
                                    text = "Log-Testpilot-1"
                                }
                                createLogCSV(filename: text) { fileCreated in
                                    if !fileCreated {
                                        presentErrorAlert = true
                                    } else {
                                        print("Create logfile with name \(text)")
                                    }
                                }
                            }
                        }
                    )
                    
                    // Alert to inform user filename is already in use
                    .alert(Text("Error"), isPresented: $presentErrorAlert, actions: {
                        Button("OK", role: .cancel) {presentErrorAlert = false }
                        
                    }, message: {Text("Filename already in use")})
                    
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
