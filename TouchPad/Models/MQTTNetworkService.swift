//
//  MQTTNetworkService.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation
import CocoaMQTT

class MQTTNetworkService: CocoaMQTTDelegate {
    
    
    
    

    let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
    let host = "localhost"
    let port: UInt16 = 1883
    let username = ""
    let password = ""
    let connectProperties = MqttConnectProperties()
    var mqtt: CocoaMQTT?
    weak var delegate: MQTTNetworkServiceDelegate?
    
    func openMQTT() {
        
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        
        mqtt = CocoaMQTT(clientID: self.clientID, host: self.host, port: self.port)
        mqtt?.username = self.username
        mqtt?.password = self.password
//        mqtt?.connectProperties = connectProperties
//        mqtt?.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt?.keepAlive = 60
        mqtt?.delegate = self
        print("[MQTT] Open MQTT session")
        mqtt?.connect()
    }
    
    func closeMQTT() {
        mqtt?.disconnect()
    }

    func sendMessage(_ message: String, topic: String) {
        mqtt?.publish(topic, withString: message)
    }
    
    func receiveMessage(topic: String) {
        mqtt?.subscribe(topic)
    }
}

extension MQTTNetworkService {
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("[MQTT] Ping sent")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("[MQTT] Pong received")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        delegate?.didUpdateConnection(isOpen: false)
        print("[MQTT] Server disconnected with error: \(err)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        delegate?.didUpdateConnection(isOpen: true)
        print("[MQTT] Server connected")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("[MQTT] Published message acknowledged")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("[MQTT] Message received \(message)")
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
