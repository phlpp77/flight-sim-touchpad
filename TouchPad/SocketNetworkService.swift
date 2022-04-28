//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

class SocketNetworkService: NSObject, URLSessionWebSocketDelegate {
    
    var webSocket: URLSessionWebSocketTask?
    @Published var isConnectionOpen = false
    
    override init() {
        super.init()
        
        let urlString = "ws://192.168.103.103:2048/fsuipc/"
        //        let urlString = "ws://localhost:2048"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            webSocket = session.webSocketTask(with: url, protocols: ["fsuipc"])
            print("[SocketNetworkService] WebSocket session started")
        }
    }
    
    func openWebSocket() {
        webSocket?.resume()
        print("[SocketNetworkService] Try to resume/open webSocket")
    }
    
    func closeWebSocket() {
        //        webSocket?.cancel(with: <#T##URLSessionWebSocketTask.CloseCode#>, reason: <#T##Data?#>)
    }
    
    // MARK: - Send and Receive
    
    func sendString(_ message: String) {

        webSocket?.send(URLSessionWebSocketTask.Message.string(message)) { error in
            if let error = error {
                print("[SendString] Failed to send with error \(error.localizedDescription)")
            }
        }
    }
    
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
    
    func sendData(_ data: Data) {
        
        print("[SendDate] Connection open: \(isConnectionOpen)")
        webSocket?.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                print("[SocketNetworkService] SendData failed with error \(error.localizedDescription)")
            }
        }
    }
    
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
    
    // MARK: - Flight simulator functions
    
    // MARK: Declare offsets
    func declareOffsets() {
        print("[declareOffsets] start")
        let declareOffsets = Offsets(command: "offsets.declare",
                                     name: "OffsetsWrite",
                                     offsets: [
                                        DeclareOffset(name: "speed", address: 16906, type: "int", size: 2),
                                        DeclareOffset(name: "altitude", address: 16908, type: "int", size: 2),
                                        DeclareOffset(name: "heading", address: 16910, type: "int", size: 2),
                                        DeclareOffset(name: "TurnFactor", address: 16912, type: "int", size: 1)
                                     ]
        )
        
        sendOffset(declareOffsets)
        print("[declareOffsets] answer: \(receiveMessage())")
    }
    
    // MARK: Change speed
    func changeSpeed(_ speed: Int) {
        print("[changeSpeed] start")
        let changeSpeedOffset = Offsets(command: "offsets.write", name: "OffsetsWrite", offsets: [WriteOffset(name: "speed", value: speed)])
        sendOffset(changeSpeedOffset)
        print("[changeSpeed] answer: \(receiveMessage())")
    }
    
}

// Extension for callback functions
extension SocketNetworkService {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("[SocketNetworkService] WebSocket connection opened")
        isConnectionOpen = true
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("[SocketNetworkService] WebSocket connection closed")
        isConnectionOpen = false
    }
}
