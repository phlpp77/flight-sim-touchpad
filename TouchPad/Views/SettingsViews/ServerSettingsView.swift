//
//  ServerSettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 21.06.22.
//

import SwiftUI

struct ServerSettingsView: View {
    
    @EnvironmentObject var socketNetworkVM: SocketNetworkViewModel
    @EnvironmentObject var mqttNetworkVM: MQTTNetworkViewModel
    
    @State private var mqttMessage = ""
    @State private var mqttTopic = "fcu/status"
    @State private var subscribingTopic = "test/foo"
    @State private var speedText = ""
    @State private var ipConfigText = "XXX"
    
    @State private var isPerformingTask = false
    
    var body: some View {
        
        Form {
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
                
                HStack {
                    Text("Select IP address")
                    Spacer(minLength: 250)
                    Picker(selection: $mqttNetworkVM.toggleIPConfig, label: Text("Select IP adress")) {
                        Text("Lab").tag(IPConfig.lab)
                        Text("Localhost").tag(IPConfig.localhost)
                        TextField("Test", text: $ipConfigText).tag(IPConfig.custom(ipConfigText))
                    }
                    .pickerStyle(.segmented)
                }
                
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
        }
        .font(.body)
        .navigationTitle(Text("Server settings"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ServerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ServerSettingsView()
    }
}
