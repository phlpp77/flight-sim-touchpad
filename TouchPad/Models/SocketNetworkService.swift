//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

class SocketNetworkService: NSObject, URLSessionWebSocketDelegate {
    
    var webSocket: URLSessionWebSocketTask?
    var isConnectionOpen = false
    weak var delegate: SocketNetworkServiceDelegate?
    
    // MARK: - Open and close connection
    
    // MARK: Open WebSocket connection
    func openWebSocket() {
        if let url = URL(string: Constants.URL_STRING) {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            webSocket = session.webSocketTask(with: url, protocols: ["fsuipc"])
            print("[openWebSocket] WebSocket session started on URL: \(url)")
        }
        webSocket?.resume()
        print("[openWebSocket] Resume WebSocket session")
    }
    
    // MARK: Close WebSocket connection
    func closeWebSocket() {
        webSocket?.cancel(with: .normalClosure, reason: Data("Connection closed with closeWebSocket function".utf8))
    }
    
    // MARK: - Send and Receive
    
    // MARK: Send a message as String
    func sendString(_ message: String) {
        
        webSocket?.send(URLSessionWebSocketTask.Message.string(message)) { error in
            if let error = error {
                print("[sendString] Failed to send with error \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Send data as Data
    func sendData(_ data: Data) {
        
        webSocket?.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                print("[sendData] Failed to send with error \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Send offset as OffsetType of Flight Simulator
    func sendOffset<OffsetType>(_ offsetPackage: Offsets<OffsetType>) {
        
        let jsonEncoder = JSONEncoder()
        
        do {
            // encode swift object to JSON object
            let encodedPackage = try jsonEncoder.encode(offsetPackage)
            
            // convert JSON object to JSON string
            let jsonStringPackage = String(data: encodedPackage, encoding: .utf8)
            
            
            if let jsonString = jsonStringPackage {
                print("[SendOffset] JSON string to send: \(String(describing: jsonString))")
                
                sendString(jsonString)
                
            } else {
                print("[SendOffset] JSON object cannot be converted to JSON string")
            }
            
        } catch {
            print("[SendOffset] \(error.localizedDescription)")
        }
        
    }
    
    // MARK: Receive message as String
    func receiveMessage() -> String {
        
        var outputMessage = "Empty"
        if !isConnectionOpen {
            openWebSocket()
        }
        
        
        
        webSocket?.receive(completionHandler: { result in
            print("[receiveMessage] start")
            switch result {
            case .failure(let error):
                print("[receiveMessage] \(result) \(error.localizedDescription)")
                outputMessage = String(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let messageString):
                    print("[receiveMessage] Received string: \(messageString)")
                    outputMessage = String(messageString)
                case .data(let data):
                    print("[receiveMessage] Received data: \(data.description)")
                    outputMessage = String(data.description)
                default:
                    print("[receiveMessage] Unknown type received from WebSocket")
                    outputMessage = "Unknown type received from WebSocket"
                }
            }
            //            self?.receiveMessage()
            
        })
        return outputMessage
    }
    
    func fetchMessage() async throws -> String {
        let (result) = try await webSocket?.receive()
        return result.debugDescription
    }
    
    // MARK: - Flight simulator
    
    // MARK: Declare offsets
    func declareOffsets() async {
        print("[declareOffsets] start")
        let declareOffsets = Offsets(
            command: "offsets.declare",
            name: "OffsetsWrite",
            offsets: [
                DeclareOffset(name: "speed", address: 16906, type: "int", size: 2),
                DeclareOffset(name: "altitude", address: 16908, type: "int", size: 2),
                DeclareOffset(name: "heading", address: 16910, type: "int", size: 2),
                DeclareOffset(name: "TurnFactor", address: 16912, type: "int", size: 1),
                DeclareOffset(name: "flaps", address: 3036, type: "int", size: 4),
                DeclareOffset(name: "gear", address: 3048, type: "int", size: 4),
                DeclareOffset(name: "spoiler", address: 16913, type: "int", size: 2),
                DeclareOffset(name: "verticalSpeed", address: 16915, type: "int", size: 2),
                DeclareOffset(name: "navZoomFactor", address: 16917, type: "int", size: 2)
            ]
        )
        
        sendOffset(declareOffsets)
        var message = ""
        do {
            message = try await fetchMessage()
            print("[declareOffsets] answer: \(message)")
        } catch {
            print("[declareOffsets] error: \(error)")
        }
        if message.contains("true") {
            delegate?.didUpdateOffsetDeclare(declared: true)
        } else {
            delegate?.didUpdateOffsetDeclare(declared: false)
        }
    }
    
    // MARK: Change speed
    func changeSpeed(_ speed: Int) {
        print("[changeSpeed] start")
        let changeSpeedOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "speed", value: speed)])
        sendOffset(changeSpeedOffset)
        print("[changeSpeed] answer: \(receiveMessage())")
    }
    
    // MARK: Change altitude
    func changeAltitude(_ altitude: Int) {
        print("[changeAltitude] start")
        let changeAltitudeOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "altitude", value: altitude)])
        sendOffset(changeAltitudeOffset)
        print("[changeAltitude] answer: \(receiveMessage())")
    }
    
    // MARK: Change heading
    func changeHeading(_ heading: Int, turnFactor: Int) {
        print("[changeHeading] start")
        let changeHeadingOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [
            WriteOffset(name: "TurnFactor", value: turnFactor),
            WriteOffset(name: "heading", value: heading)
        ])
        sendOffset(changeHeadingOffset)
        print("[changeHeading] answer: \(receiveMessage())")
    }
    
    // MARK: Change flaps
    func changeFlaps(_ flaps: Int) {
        print("[changeFlaps] start")
        let changeFlapsOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "flaps", value: flaps)])
        sendOffset(changeFlapsOffset)
        print("[changeFlaps] answer: \(receiveMessage())")
    }
    
    // MARK: Change gear
    func changeGear(_ gear: Int) {
        print("[changeGear] start")
        let changeGearOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "gear", value: gear)])
        sendOffset(changeGearOffset)
        print("[changeGear] answer: \(receiveMessage())")
    }
    
    // MARK: Change spoilers
    func changeSpoiler(_ spoiler: Int) {
        print("[changeSpoiler] start")
        let changeSpoilerOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "spoiler", value: spoiler)])
        sendOffset(changeSpoilerOffset)
        print("[changeSpoiler] answer: \(receiveMessage())")
    }
    
    // MARK: Change vertical speed
    func changeVerticalSpeed(_ verticalSpeed: Int) {
        print("[changeVerticalSpeed] start")
        let changeVerticalSpeedOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "verticalSpeed", value: verticalSpeed)])
        sendOffset(changeVerticalSpeedOffset)
        print("[changeVerticalSpeed] answer: \(receiveMessage())")
    }
    
    // MARK: Change zoom factor of nav display
    func changeNavZoomFactor(_ zoomFactor: Int) {
        print("[changeNavZoomFactor] start")
        let changeNavZoomFactorOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "navZoomFactor", value: zoomFactor)])
        sendOffset(changeNavZoomFactorOffset)
        print("[changeNavZoomFactor] answer: \(receiveMessage())")
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let URL_STRING = "ws://192.168.103.103:2048/fsuipc/"
        //        static let URL_STRING = "ws://localhost:2048"
    }
    
}

// MARK: - Extension for callback functions
extension SocketNetworkService {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("[SocketNetworkService] WebSocket connection opened")
        isConnectionOpen = true
        delegate?.didUpdateConnection(isOpen: true)
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("[SocketNetworkService] WebSocket connection closed")
        isConnectionOpen = false
        delegate?.didUpdateConnection(isOpen: false)
    }
}

protocol SocketNetworkServiceDelegate: AnyObject {
    
    func didUpdateConnection(isOpen: Bool)
    
    func didUpdateOffsetDeclare(declared: Bool)
}
