//
//  MQTTNetworkViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation

class MQTTNetworkViewModel: ObservableObject {
    
    @Published var mqttService = MQTTNetworkService()
    @Published var connectionOpen = false
    
    init() {
        mqttService.delegate = self
    }
    
    func connectToMQTTServer() {
        mqttService.openMQTT()
    }
    
    func sendToLog(_ logdata: LogData) {
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(logdata)
            mqttService.sendMessage(String(data: data, encoding: .utf8)!, topic: "fcu/log")
        } catch  {
            print("error while encoding")
        }
        
    }
    
    func sendMessage(_ message: String, topic: String) {
        mqttService.sendMessage(message, topic: topic)
    }
    
    func receiveMessage(topic: String) {
        mqttService.receiveMessage(topic: topic)
    }
}

extension MQTTNetworkViewModel: MQTTNetworkServiceDelegate {

    func didUpdateConnection(isOpen: Bool) {
        DispatchQueue.main.async {
            self.connectionOpen = isOpen
        }
    }
}
