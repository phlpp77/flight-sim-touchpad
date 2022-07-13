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
        self.updateMasterWarn()
        self.updateMasterCaution()
        
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
        state.didSetMasterWarn
            .sink {
                self.updateMasterWarn()
            }
            .store(in: &subscriptions)
        state.didSetMasterCaution
            .sink {
                self.updateMasterCaution()
            }
            .store(in: &subscriptions)
        
    }
    
    // MARK: Vars that are used inside the view
    @Published public var zoomFactor: Int!
    @Published public var masterWarn: Bool!
    @Published public var masterCaution: Bool!
    
    // MARK: Vars that are used only inside ViewModel
    private var oldZoomFactor: Int = 0
    private var oldMasterWarn: Int = 0
    private var oldMasterCaution: Int = 0
    
    // MARK: Functions/Vars to interact with the state
    public var toggleZoomFactor: Int {
        get {
            self.zoomFactor
        }
        set {
            SoundService.shared.tockSound()
            state.changeAircraftData(of: .navZoomFactor, to: newValue)
            saveAndSendNavZoomData()
        }
    }
    
    public func deactivateMasterWarn() {
        if masterWarn {
            SoundService.shared.tockSound()
            sendDataToMQTT(state: .masterWarn, value: masterWarn)
        }
    }
    
    public func deactivateMasterCaution() {
        if masterCaution {
            SoundService.shared.tockSound()
            sendDataToMQTT(state: .masterCaution, value: masterCaution)
        }
    }
    
    // MARK: Update functions to be called from state via combine
    private func updateZoomFactor() {
        zoomFactor = state.aircraftData.navZoomFactor
    }
    
    private func updateMasterWarn() {
        masterWarn = state.aircraftStates.masterWarn
    }
    
    private func updateMasterCaution() {
        masterCaution = state.aircraftStates.masterCaution
    }
    
    // MARK: Functions to interact with server / log
    private func saveAndSendNavZoomData() {
        print("NAV zoom factor set from: \(oldZoomFactor) to \(zoomFactor!) at \(Date().localFlightSim())")
        
        // MARK: Save to log
        // Create Log component
        let logData = LogData(attribute: "navZoom", oldValue: Double(oldZoomFactor), value: Double(zoomFactor), startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
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
    
    private func sendDataToMQTT(state type: AircraftStatesType, value: Bool) {
        print("\(type.rawValue) set to \(value) at \(Date().localFlightSim())")
        
        // Create Log component
        let logData = LogData(attribute: type.rawValue, value: Double(value ? 1 : 0), startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
        // Add to local log on iPad
        log.append(logData)
        // Add to remote log via MQTT
        if mqttVM.connectionOpen {
            mqttVM.sendToLog(logData)
        }
    }
}
