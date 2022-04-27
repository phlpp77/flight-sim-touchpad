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
                print("[SocketNetworkService] SendString failed with error \(error.localizedDescription)")
            }
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
        print("[receiveMessage] Connection open: \(isConnectionOpen)")
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
    
    func declareOffsets() -> String {
        print("[declareOffsets] start")
        let declarePackage = OffsetsDeclare()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dataEncodingStrategy = .deferredToData
        do {
            let encodedDeclarePackage = try jsonEncoder.encode(declarePackage)
            print("[declareOffsets] send data")
            sendData(encodedDeclarePackage)
        } catch {
            print("[declareOffsets] \(error.localizedDescription)")
        }
        let message = receiveMessage()
        return message
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
