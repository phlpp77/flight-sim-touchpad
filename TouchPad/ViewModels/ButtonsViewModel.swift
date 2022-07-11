//
//  ButtonsViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 11.07.22.
//

import Foundation
import Combine

class ButtonsViewModel: ObservableObject {
    
    // MARK: Initial setup
    private var state: TouchPadModel
    private var webSocketVM: SocketNetworkViewModel
    private var mqttVM: MQTTNetworkViewModel
    init(state: TouchPadModel, webSocket: SocketNetworkViewModel, mqtt: MQTTNetworkViewModel) {
        self.state = state
        self.webSocketVM = webSocket
        self.mqttVM = mqtt
        self.updateZoomFactor()
        
        // setup the combine subscribers
        setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        state.didSetNavZoomFactor
            .sink {
                self.updateZoomFactor()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Vars that are used inside the view
    @Published public var zoomFactor: Int!
    
    // MARK: Vars that are used only inside ViewModel
    private var oldZoomFactor: Int = 0
    
    // MARK: Functions/Vars to interact with the state
    public var toggleZoomFactor: Int {
        get {
            self.zoomFactor
        }
        set {
            state.changeAircraftData(of: .navZoomFactor, to: newValue)
        }
    }
    
    // MARK: Update functions to be called from state via combine
    private func updateZoomFactor() {
        zoomFactor = state.aircraftData.navZoomFactor
        saveAndSendData()
    }
    
    // MARK: Functions to interact with server / log
    private func saveAndSendData() {
        print("NAV zoom factor set from: \(oldZoomFactor) to \(zoomFactor!) at \(Date().localFlightSim())")
        
        // MARK: Save to log
        // Create Log component
        let logData = LogData(attribute: "NavZoom", oldValue: Double(oldZoomFactor), value: Double(zoomFactor), startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
        // Add to local log on iPad
        log.append(logData)
        // Add to remote log via MQTT
        if mqttVM.connectionOpen {
            mqttVM.sendToLog(logData)
        }
        
        // MARK: Update values
        // Update remote value via WebSocket
        if webSocketVM.offsetsDeclared {
            webSocketVM.changeValue(of: .navZoomFactor, to: zoomFactor)
        }
        
        // Reset the old value
        oldZoomFactor = zoomFactor
    }
}
