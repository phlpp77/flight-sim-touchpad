//
//  MQTTNetworkService.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 15.06.22.
//

import Foundation
import CocoaMQTT

class MQTTNetworkService: CocoaMQTT5Delegate {

    let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
    let host = ""
    let port: UInt16 = 1883
    let username = ""
    let password = ""
    let connectProperties = MqttConnectProperties()
    var mqtt: CocoaMQTT5?
    
    func openMQTT() {
        
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        
        mqtt = CocoaMQTT5(clientID: self.clientID, host: self.host, port: self.port)
        mqtt?.username = self.username
        mqtt?.password = self.password
        mqtt?.connectProperties = connectProperties
        mqtt?.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt?.keepAlive = 60
        mqtt?.delegate = self
        mqtt?.connect()
    }

    func sendMessage(_ message: String, topic: String) {
        mqtt?.publish(topic, withString: message, properties: MqttPublishProperties())
    }
}

extension MQTTNetworkService {
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck) {
        print(connAckData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        print(message)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck) {
        print(pubAckData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec) {
        print(pubRecData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish) {
        print(publishData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck) {
        print(subAckData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], UnsubAckData: MqttDecodeUnsubAck) {
        print(UnsubAckData)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        print("[MQTT] Disconnected: \(reasonCode)")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        print("[MQTT] AuthReasonCode: \(reasonCode)")
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        print("[MQTT] Ping send")
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        print("[MQTT] Pong received")
    }
    
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        print("[MQTT] Disconnected with error: \(err!)")
    }
}
