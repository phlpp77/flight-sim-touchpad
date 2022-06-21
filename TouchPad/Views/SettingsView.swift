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
    @ObservedObject var mqttNetworkVM: MQTTNetworkViewModel
    
    @State private var mqttMessage = ""
    @State private var mqttTopic = "fcu/status"
    @State private var subscribingTopic = ""
    
    @State private var speedText = ""
    @State private var fileName = ""
    @State private var presentFileNameAlert = false
    @State private var presentErrorAlert = false
    @State private var presentDoneAlert = false
    
    @State private var isPerformingTask = false
    
    var body: some View {
        
        NavigationView {
            Form {
                
                HStack(spacing: 14) {
                    Spacer()
                    StatusField(
                        title: "WebSocket Server",
                        status: socketNetworkVM.connectionOpen ? "Connected" : "Not connected",
                        statusIcon: socketNetworkVM.connectionOpen ? "externaldrive.fill.badge.checkmark" : "externaldrive.badge.xmark",
                        statusColor: socketNetworkVM.connectionOpen ? Color.green : Color.gray
                    )
                    .onTapGesture {
                        socketNetworkVM.toggleServerConnection.toggle()
                    }
                    
                    StatusField(
                        title: "WebSocket Offsets",
                        status: socketNetworkVM.offsetsDeclared ? "Declared" : "Not declared",
                        statusIcon: socketNetworkVM.offsetsDeclared ? "folder.fill" : "questionmark.folder",
                        statusColor: socketNetworkVM.offsetsDeclared ? Color.green : Color.gray
                    )
                    .onTapGesture {
                        Task {
                            await socketNetworkVM.webSocketService.declareOffsets()
                        }
                    }
                    
                    StatusField(
                        title: "MQTT Server",
                        status: mqttNetworkVM.connectionOpen ? "Connected" : "Not connected",
                        statusIcon: mqttNetworkVM.connectionOpen ? "externaldrive.fill.badge.checkmark" : "externaldrive.badge.xmark",
                        statusColor: mqttNetworkVM.connectionOpen ? Color.green : Color.gray
                    )
                    .onTapGesture {
                        mqttNetworkVM.toggleServerConnection.toggle()
                    }
                    Spacer()
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground)) // Change color from white to background
                .listRowInsets(EdgeInsets()) // remove insets so cards are inline with rest
                
                
                Section(header: Text("Appearance")) {
                    
                    // MARK: Show tap indicators
                    Toggle(isOn: $appearanceVM.showTapIndicator) {
                        Text("Show tap indicators")
                    }
                    
                    // MARK: Lock the speed every five steps
                    Toggle(isOn: $appearanceVM.speedStepsInFive) {
                        Text("Lock speed every five steps")
                    }
                    
                    // MARK: Lock the heading every five steps
                    Toggle(isOn: $appearanceVM.headingStepsInFive) {
                        Text("Lock heading every five steps")
                    }
                }
                
                
                Section(header: Text("Web Socket"), footer: Text("Without a connection to the Web Socket server it is not possible to run this app satisfactory")) {
                    
                    // MARK: Connect to WebSocket Server
                    Toggle(isOn: $socketNetworkVM.toggleServerConnection) {
                        Text("Connect WebSocket Server")
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
                    
                }
                
                Section(header: Text("MQTT")) {
                    
                    Toggle(isOn: $mqttNetworkVM.toggleServerConnection) {
                        Text("Connect MQTT Server")
                    }
                    
                    HStack {
                        TextField("Topic", text: $mqttTopic)
                        TextField("Message", text: $mqttMessage)
                        Button {
                            mqttNetworkVM.sendMessage(mqttMessage, topic: mqttTopic)
                        } label: {
                            Text("Send message")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        TextField("Topic", text: $subscribingTopic)
                        Button {
                            mqttNetworkVM.receiveMessage(topic: subscribingTopic)
                        } label: {
                            Text("Subscribe")
                                .foregroundColor(.blue)
                        }
                        
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
                    
                    
                }
                
                Section(header: Text("Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("v1.1.0-beta")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Contact")
                        Spacer()
                        Text("Philipp Hemkemeyer")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Copyright")
                        Spacer()
                        Text("2022 | Airbus SE")
                            .foregroundColor(.gray)
                    }
                }
                
                
                Rectangle()
                    .opacity(0)
                    .frame(height: 1)
                    
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
                                    presentDoneAlert = true
                                }
                            }
                        }
                    }
                )
                
                // Alert to inform user filename is already in use
                .alert(Text("Error"), isPresented: $presentErrorAlert, actions: {
                    Button("OK", role: .cancel) {presentErrorAlert = false }
                    
                }, message: {Text("Filename already in use")})
                // Alert to inform user file is created and can be found in "Files" app
                .alert(Text("Success"), isPresented: $presentDoneAlert, actions: {
                    Button("OK", role: .cancel) {presentDoneAlert = false }
                    
                }, message: {Text("File was created successfully and can be found in Files app on this iPad")})
                
                .listRowBackground(Color(UIColor.systemGroupedBackground)) // Change color from white to background
                .listRowInsets(EdgeInsets()) // remove insets so cards are inline with rest
                
            }
            .foregroundColor(.primary)
            .font(.body)
            .navigationTitle(Text("Settings"))
            .navigationViewStyle(.stack)
        }
        .accessibilityLabel("Settings")
    }
    
    
    
    
    
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
                .font(.title3)
                .bold()
                .foregroundColor(.black)
            
            Spacer()
            Text("Status: \(status)")
                .foregroundColor(statusColor)
                .padding(.top, 1)
            Image(systemName: statusIcon)
                .font(.largeTitle)
                .foregroundColor(statusColor)
            
            
        }
        .padding(2)
        .frame(width: 150, height: 150)
        .background(.white)
        .cornerRadius(20)
    }
}

struct StatusField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
            StatusField(title: "WebSocket Server", status: "Not connected", statusIcon: "externaldrive.fill.badge.checkmark", statusColor: .gray)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let appearanceVM = AppearanceViewModel()
        let socketNetworkVM = SocketNetworkViewModel()
        let mqttNetworkVM = MQTTNetworkViewModel()
        SettingsView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
