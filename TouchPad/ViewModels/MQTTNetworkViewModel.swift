//
//  MQTTNetworkViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation

class MQTTNetworkViewModel: ObservableObject {
    
    @Published var mqttService = MQTTNetworkService()
    
    func connectToMQTTServer() {
        mqttService.openMQTT()
    }
    
    func sendMessage(_ message: String, topic: String) {
        mqttService.sendMessage(message, topic: topic)
    }
    
    func receiveMessage(topic: String) {
        mqttService.receiveMessage(topic: topic)
    }
}
