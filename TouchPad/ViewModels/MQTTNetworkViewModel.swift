//
//  MQTTNetworkViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation
import Combine

class MQTTNetworkViewModel: ObservableObject {
    
    let mqttService = MQTTNetworkService.shared
    @Published var connectionOpen = false
    
    init() {
        mqttService.delegate = self
    }
    
    var toggleServerConnection: Bool = false {
        willSet {
            if newValue == true {
                if !connectionOpen {
                    mqttService.openMQTT()
                }
            } else {
                mqttService.closeMQTT()
            }
        }
    }
    
    // Open the connection to the MQTT server if not already connected
    func openConnection() {
        if !connectionOpen {
            mqttService.openMQTT()
        }
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
            self.toggleServerConnection = isOpen
        }
    }
}
