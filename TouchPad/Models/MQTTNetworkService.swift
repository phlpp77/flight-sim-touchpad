//
//  MQTTNetworkService.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation
import CocoaMQTT
import Combine

class MQTTNetworkService: CocoaMQTTDelegate {
    
    private let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
    var host: String?
    private let port: UInt16 = 1883
    private let username = ""
    private let password = ""
    private let connectProperties = MqttConnectProperties()
    private var mqtt: CocoaMQTT?
    
    static let shared = MQTTNetworkService()
    weak var delegate: MQTTNetworkServiceDelegate?
    let didReceiveMessage = PassthroughSubject<CocoaMQTTMessage, Never>()
    let didConnectToMQTT = PassthroughSubject<Void, Never>()
    let didDisconnectToMQTT = PassthroughSubject<Void, Never>()
    
    
    /// Function to open the MQTT connection
    func openMQTT() {
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        mqtt = CocoaMQTT(clientID: self.clientID, host: self.host!, port: self.port)
        mqtt?.username = self.username
        mqtt?.password = self.password
        mqtt?.willMessage = CocoaMQTTMessage(topic: "/will", string: "connection lost")
        mqtt?.keepAlive = 120
        mqtt?.delegate = self
        print("[MQTT] Open MQTT session with host \(host!)")
        _ = mqtt?.connect()
    }
    
    /// Function to close the MQTT connection # Heading
    func closeMQTT() {
        mqtt?.disconnect()
    }
    
    /// Function to send a MQTT message as a String and a certain topic
    func sendMessage(_ message: String, topic: String) {
        mqtt?.publish(topic, withString: message)
    }
    
    /// Function to subscribe to a topic to receive messages send to it
    func receiveMessage(topic: String) {
        mqtt?.subscribe(topic)
    }
    
    
}

// MARK: - MQTT callbacks
extension MQTTNetworkService {
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("[MQTT] Ping sent")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("[MQTT] Pong received")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        delegate?.didUpdateConnection(isOpen: false)
        didDisconnectToMQTT.send()
        let error = err?.localizedDescription ?? "No error mentioned"
        print("[MQTT] Server disconnected with error: \(error)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        delegate?.didUpdateConnection(isOpen: true)
        didConnectToMQTT.send()
        print("[MQTT] Server connected")
        
        // MARK: Subscribe to topics after connection is made
        receiveMessage(topic: "fcu/#")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("[MQTT] Published message acknowledged")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("[MQTT] Message received in topic \(message.topic) with payload \(message.string!)")
        didReceiveMessage.send(message)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("[MQTT] Message published")
    }
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("[MQTT] Subscribed to topics")
    }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("[MQTT] Unsubscribe from topics")
    }
}

protocol MQTTNetworkServiceDelegate: AnyObject {
    
    func didUpdateConnection(isOpen: Bool)
    
}
