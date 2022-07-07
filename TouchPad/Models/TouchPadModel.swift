//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation
import Combine
import CocoaMQTT
import AVFoundation

class TouchPadModel {
    
    @Published public var settings = TouchPadSettings()
    @Published public var aircraftData = AircraftData()
    @Published public var serviceData = ServiceData()
    
    // Setup of MQTT service and combine
    let mqttService = MQTTNetworkService.shared
    
    // MARK: Combine setup
    
    // Settings updates
    let didSetShowTapIndicator = PassthroughSubject<Void, Never>()
    let didSetSpeedStepsInFive = PassthroughSubject<Void, Never>()
    let didSetHeadingStepsInFive = PassthroughSubject<Void, Never>()
    let didSetScreen = PassthroughSubject<Void, Never>()
    let didSetSliderSoundEffect = PassthroughSubject<Void, Never>()
    let didSetShowTestValueWindow = PassthroughSubject<Void, Never>()
    
    // Aircraft data updates
    let didSetSpeed = PassthroughSubject<Void, Never>()
    let didSetAltitude = PassthroughSubject<Void, Never>()
    let didSetHeading = PassthroughSubject<Void, Never>()
    let didSetFlaps = PassthroughSubject<Void, Never>()
    let didSetGear = PassthroughSubject<Void, Never>()
    let didSetSpoiler = PassthroughSubject<Void, Never>()
    let didSetIPConfig = PassthroughSubject<Void, Never>()
    let didSetVerticalSpeed = PassthroughSubject<Void, Never>()
    // Update of all aircraft data
    let didSetAircraftData = PassthroughSubject<Void, Never>()
    
    // Service data updates
    let didSetATCMessage = PassthroughSubject<Void, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        mqttService.didReceiveMessage
            .sink { message in
                self.handleMessages(message: message)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: Model for Settings
    struct TouchPadSettings {
        var showTapIndicator: Bool = false
        var speedStepsInFive: Bool = true
        var headingStepsInFive: Bool = true
        var screen: Screen = .essential
        var sliderSoundEffect: Bool = true
        var showTestValueWindow: Bool = false
        var webSocketConnectionIsOpen: Bool = false
        var ipConfig: IPConfig = .lab
    }
    
    // MARK: Model for Aircraft data
    struct AircraftData: Codable {
        var speed: Int = 250
        var heading: Double = 0
        var altitude: Int = 10000
        var flaps: Int = 0
        var gear: Int = 0
        var spoiler: Int = 0
        var verticalSpeed: Int = 100
    }
    
    // MARK: Model for additional service data
    struct ServiceData: Codable {
        var atcMessage: String = ""
        var showDuration: Double = 60
    }
    
    // MARK: - Functions to change model data
    func changeTapIndicator(_ newState: Bool) {
        settings.showTapIndicator = newState
        didSetShowTapIndicator.send()
    }
    func changeSpeedStepsInFive(_ newState: Bool) {
        settings.speedStepsInFive = newState
        didSetSpeedStepsInFive.send()
    }
    func changeHeadingStepsInFive(_ newState: Bool) {
        settings.headingStepsInFive = newState
        didSetHeadingStepsInFive.send()
    }
    func changeScreen(_ newState: Screen) {
        settings.screen = newState
        didSetScreen.send()
    }
    func changeSliderSoundEffect(_ newState: Bool) {
        settings.sliderSoundEffect = newState
        didSetSliderSoundEffect.send()
    }
    func changeShowTestValueWindow(_ newState: Bool) {
        settings.showTestValueWindow = newState
        didSetShowTestValueWindow.send()
    }
    func changeIPConfig(_ newState: IPConfig) {
        settings.ipConfig = newState
        didSetIPConfig.send()
    }
    
    func changeAircraftData(of valueType: AircraftDataType, to value: Int) {
        switch valueType {
        case .speed:
            aircraftData.speed = value
            didSetSpeed.send()
        case .altitude:
            aircraftData.altitude = value
            didSetAltitude.send()
        case .heading:
            aircraftData.heading = Double(value)
            didSetHeading.send()
        case .flaps:
            aircraftData.flaps = value
            didSetFlaps.send()
        case .gear:
            aircraftData.gear = value
            didSetGear.send()
        case .spoiler:
            aircraftData.spoiler = value
            didSetSpoiler.send()
        case .verticalSpeed:
            aircraftData.verticalSpeed = value
            didSetVerticalSpeed.send()
        }
    }

    func changeATCMessage(message: String, duration: Double) {
        serviceData.atcMessage = message
        serviceData.showDuration = duration
        didSetATCMessage.send()
    }
    
    // MARK: - Functions to handle MQTT incoming messages
    private func handleMessages(message: CocoaMQTTMessage) {
        let topic = message.topic
        let jsonString = message.string!.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        switch topic {
        case "fcu/aircraft/data":
            do {
                let aircraftData = try decoder.decode(MQTTAircraftData.self, from: jsonString)
                handleAircraftData(mqttData: aircraftData)
            } catch {
                print("[MQTT message handler] error: \(error.localizedDescription)")
            }
        case "fcu/service/atc":
            do {
                let serviceData = try decoder.decode(MQTTServiceData.self, from: jsonString)
                handleServiceData(mqttData: serviceData)
            } catch {
                print("[MQTT message handler] error: \(error.localizedDescription)")
            }
        default:
            print("[MQTT message handler] topic \(topic) not found")
        }
    }
    
    private func handleAircraftData(mqttData: MQTTAircraftData) {
        switch mqttData.type {
        case "aircraftStartValues":
            changeAircraftStartValues(values: mqttData.data)
        default:
            print("[MQTT aircraftData handler] type \(mqttData.type) not found")
        }
    }
    
    private func handleServiceData(mqttData: MQTTServiceData) {
        switch mqttData.type {
        case "atcMessage":
            changeATCMessage(message: mqttData.data.atcMessage, duration: mqttData.data.showDuration)
        default:
            print("[MQTT serviceData handler] type \(mqttData.type) not found")
        }
    }
    
    private func changeAircraftStartValues(values: AircraftData) {
        print("set speed to values: \(values)")
        changeAircraftData(of: .speed, to: values.speed)
        changeAircraftData(of: .altitude, to: values.altitude)
        changeAircraftData(of: .heading, to: Int(values.heading))
        changeAircraftData(of: .spoiler, to: values.spoiler)
        changeAircraftData(of: .gear, to: values.gear)
        changeAircraftData(of: .flaps, to: values.flaps)
        changeAircraftData(of: .verticalSpeed, to: values.verticalSpeed)
        didSetAircraftData.send()
        
        // Voice feedback
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Values have been set.")
        speechUtterance.rate = 0.55
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
    
    struct MQTTAircraftData: Codable {
        var type: String
        var data: AircraftData
    }
    
    struct MQTTServiceData: Codable {
        var type: String
        var data: ServiceData
    }
}
