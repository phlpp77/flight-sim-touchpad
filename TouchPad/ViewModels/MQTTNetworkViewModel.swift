//
//  MQTTNetworkViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation
import Combine

class MQTTNetworkViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    let mqttService = MQTTNetworkService.shared
    init(state: TouchPadModel) {
        self.state = state
        self.updateIPConfig()
        self.mqttService.delegate = self
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetIPConfig
            .sink {
                self.updateIPConfig()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var connectionOpen = false
    @Published public var ipConfig: IPConfig!
    
    // MARK: Functions/Vars to interact with the state
    // none
    
    // MARK: Update functions to be called from state via combine
    private func updateIPConfig() {
        mqttService.closeMQTT()
        ipConfig = state.settings.ipConfig
        mqttService.host = ipConfig.ip
        mqttService.openMQTT()
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
    public var toggleIPConfig: IPConfig {
        get {
            self.ipConfig
        }
        set {
            state.changeIPConfig(newValue)
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
