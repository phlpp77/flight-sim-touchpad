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
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        
        NavigationView {
            Form {
                
                // MARK: - Status Bar
                HStack(spacing: 18) {
                    Spacer()
                    // MARK: WebSocket status
                    StatusField(
                        tappable: false,
                        title: "WebSocket Server",
                        status: socketNetworkVM.connectionOpen ? "Connected" : "Not connected",
                        statusIcon: socketNetworkVM.connectionOpen ? "externaldrive.fill.badge.checkmark" : "externaldrive.badge.xmark",
                        statusColor: socketNetworkVM.connectionOpen ? Color.green : Color.gray
                    )
                    .opacity(0.6)
                    
                    // MARK: WebSocket offsets status
                    StatusField(
                        tappable: false,
                        title: "WebSocket Offsets",
                        status: socketNetworkVM.offsetsDeclared ? "Declared" : "Not declared",
                        statusIcon: socketNetworkVM.offsetsDeclared ? "folder.fill" : "questionmark.folder",
                        statusColor: socketNetworkVM.offsetsDeclared ? Color.green : Color.gray
                    )
                    .opacity(0.6)
                    
                    // MARK: MQTT status
                    StatusField(
                        tappable: true,
                        title: "MQTT Server",
                        status: mqttNetworkVM.connectionOpen ? "Connected" : "Not connected",
                        statusIcon: mqttNetworkVM.connectionOpen ? "externaldrive.fill.badge.checkmark" : "externaldrive.badge.xmark",
                        statusColor: mqttNetworkVM.connectionOpen ? Color.green : Color.gray
                    )
                    // Tap to connect to MQTT server
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            mqttNetworkVM.toggleServerConnection.toggle()
                        }
                    )
                    Spacer()
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground)) // Change color from white to background
                .listRowInsets(EdgeInsets()) // remove insets so cards are inline with rest
                .padding(.vertical, 20)
                
                // MARK: - Appearance settings
                Section(header: Text("Appearance")) {
                    
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
                    
                    // MARK: Link to further appearance settings
                    NavigationLink {
                        AppearanceSettingsView()
                    } label: {
                        Text("Further appearance settings")
                    }
                    
                }
                
                // MARK: - Log creation
                Section(header: Text("Logfiles")) {
                    
                    // MARK: Create log file
                    Button(action: {
                        presentFileNameAlert.toggle()
                    }) {
                        HStack {
                            Text("Export Log as CSV")
                            Spacer()
                        }
                    }
                }
                
                // MARK: - Advanced settings
                Section(header: Text("Advanced settings")) {
                    
                    // MARK: Link to server settings
                    NavigationLink {
                        ServerSettingsView()
                    } label: {
                        Text("Server settings")
                    }
                    
                    // MARK: Link to tone settings
                    NavigationLink {
                        ToneTestButtonView()
                    } label: {
                        Text("Tone tests")
                    }
                }
                
                // MARK: - Information about the app
                Section(header: Text("Information")) {
                    
                    // MARK: App version (pulled from Xcode project)
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("v\(appVersion!)-beta")
                            .foregroundColor(.gray)
                    }
                    
                    // MARK: App contact/Developer
                    HStack {
                        Text("Contact")
                        Spacer()
                        Text("Philipp Hemkemeyer")
                            .foregroundColor(.gray)
                    }
                    
                    // MARK: Copyright statement
                    HStack {
                        Text("Copyright")
                        Spacer()
                        Text("2022 | Airbus SE")
                            .foregroundColor(.gray)
                    }
                }
                
                // MARK: - Alerts
                
                // MARK: Invisible box to place Alerts on
                Rectangle()
                    .opacity(0)
                    .frame(height: 1)
                
                // MARK: Alert to get filename from user
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
                
                // MARK: Alert to inform user filename is already in use
                    .alert(Text("Error"), isPresented: $presentErrorAlert, actions: {
                        Button("OK", role: .cancel) {presentErrorAlert = false }
                        
                    }, message: {Text("Filename already in use")})
                
                // MARK: Alert to inform user file is created and can be found in "Files" app
                    .alert(Text("Success"), isPresented: $presentDoneAlert, actions: {
                        Button("OK", role: .cancel) {presentDoneAlert = false }
                        
                    }, message: {Text("File was created successfully and can be found in Files app on this iPad")})
            
                // Make Box invisible
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

// MARK: - StatusField at the top
struct StatusField: View {
    let tappable: Bool
    let title: String
    var status: String
    var statusIcon: String
    var statusColor: Color
    
    @State private var isPressed = false
    
    var body: some View {
        
        VStack {
            
            // MARK: Title of status field
            Text(title)
                .font(.title3)
                .bold()
                .foregroundColor(.black)
            
            Spacer()
            
            // MARK: Actual status
            Text("Status: \(status)")
                .foregroundColor(statusColor)
                .padding(.top, 1)
            
            // MARK: Actual status icon
            Image(systemName: statusIcon)
                .font(.largeTitle)
                .foregroundColor(statusColor)
        }
        .padding(2)
        .frame(width: 150, height: 150)
        .background(.white)
        .cornerRadius(20)
        .opacity(isPressed ? 0.4 : 1)
        .scaleEffect(isPressed ? 1.1 : 1)
        
        // MARK: Animation when tapped
        .pressEvents {
            if tappable {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = true
                }
            }
        } onRelease: {
            if tappable {
                withAnimation {
                    isPressed = false
                }
            }
        }
    }
}

struct StatusField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
            StatusField(tappable: true, title: "WebSocket Server", status: "Not connected", statusIcon: "externaldrive.fill.badge.checkmark", statusColor: .gray)
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
