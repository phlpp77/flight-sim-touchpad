//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var appearanceVM: AppearanceViewModel
    @EnvironmentObject var socketNetworkVM: SocketNetworkViewModel
    @EnvironmentObject var mqttNetworkVM: MQTTNetworkViewModel
    
    
    @State private var fileName = ""
    @State private var presentFileNameAlert = false
    @State private var presentErrorAlert = false
    @State private var presentDoneAlert = false
    
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
                    Toggle(isOn: $appearanceVM.toggleShowTapIndicator) {
                        Text("Show tap indicators")
                    }
                    
                    // MARK: Show test value window
                    Toggle(isOn: $appearanceVM.toggleShowTestValueWindow) {
                        Text("Show values in state")
                    }
                    
                    // MARK: Toggle slider sound effect
                    Toggle(isOn: $appearanceVM.toggleSliderSoundEffect) {
                        Text("\(appearanceVM.sliderSoundEffect ? "Disable" : "Enable") sound effects of sliders")
                    }
                    
                    // MARK: Lock the speed every five steps
                    Toggle(isOn: $appearanceVM.toggleSpeedStepsInFive) {
                        Text("Lock speed every five steps")
                    }
                    
                    // MARK: Lock the heading every five steps
                    Toggle(isOn: $appearanceVM.toggleHeadingStepsInFive) {
                        Text("Lock heading every five steps")
                    }
                    
                    // MARK: Screen selector
                    HStack {
                        Text("Select screen")
                        Spacer(minLength: 250)
                        Picker(selection: $appearanceVM.toggleScreen, label: Text("Select screen")) {
                            Text("Main screen").tag(Screen.essential)
                            Text("Secondary screen").tag(Screen.additional)
                        }
                        .pickerStyle(.segmented)
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
                
                Section(header: Text("Advanced settings")) {
                    NavigationLink {
                        ServerSettingsView()
                    } label: {
                        Text("Server settings")
                    }
                    
                    NavigationLink {
                        ToneTestButtonView()
                    } label: {
                        Text("Tone tests")
                    }
                }
                
                
                
                Section(header: Text("Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("v2.0.1-beta")
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
        SettingsView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
