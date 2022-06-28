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

class TouchPadModel: ObservableObject {
    
    @Published public var settings = TouchPadSettings()
    @Published public var aircraftData = AircraftData()
    
    // Setup of MQTT service and combine
    let mqttService = MQTTNetworkService.shared
    let didSetAircraftData = PassthroughSubject<Void, Never>()
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
    
    struct TouchPadSettings {
        var showTapIndicator: Bool = false
        var speedStepsInFive: Bool = true
        var headingStepsInFive: Bool = true
        var screen: Screen = .essential
        var sliderSoundEffect: Bool = true
        var webSocketConnectionIsOpen: Bool = false
    }
    
    struct AircraftData: Codable {
        var speed: Int = 250
        var heading: Double = 0
        var altitude: Int = 10000
        var flaps: Int = 0
        var gear: Int = 0
        var spoiler: Int = 0
    }
    
    func changeTapIndicator(_ newState: Bool) {
        settings.showTapIndicator = newState
    }
    
    func changeSpeedStepsInFive(_ newState: Bool) {
        settings.speedStepsInFive = newState
    }
    
    func changeHeadingStepsInFive(_ newState: Bool) {
        settings.headingStepsInFive = newState
    }
    
    func changeScreen(_ newState: Screen) {
        settings.screen = newState
    }
    
    func changeSliderSoundEffect(_ newState: Bool) {
        settings.sliderSoundEffect = newState
    }
    
    func changeAircraftData(of valueType: AircraftDataType, to value: Int) {
        switch valueType {
        case .speed:
            aircraftData.speed = value
        case .altitude:
            aircraftData.altitude = value
        case .heading:
            aircraftData.heading = Double(value)
        case .flaps:
            aircraftData.flaps = value
        case .gear:
            aircraftData.gear = value
        case .spoiler:
            aircraftData.spoiler = value
        }
    }
    
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
    
    private func changeAircraftStartValues(values: AircraftData) {
        print("set speed to values: \(values)")
        changeAircraftData(of: .speed, to: values.speed)
        changeAircraftData(of: .altitude, to: values.altitude)
        changeAircraftData(of: .heading, to: Int(values.heading))
        changeAircraftData(of: .spoiler, to: values.spoiler)
        changeAircraftData(of: .gear, to: values.gear)
        changeAircraftData(of: .flaps, to: values.flaps)
        // Line 1. Create an instance of AVSpeechSynthesizer.
        var speechSynthesizer = AVSpeechSynthesizer()
        // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Values have been set.")
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
        // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        speechSynthesizer.speak(speechUtterance)
    }   
    
    struct MQTTAircraftData: Codable {
        var type: String
        var data: AircraftData
    }
}
