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
    
    override init() {
        super.init()
        
//        let urlString = "ws://192.168.103.103:2048/fsuipc/"
        let urlString = "ws://localhost:2048"
        
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
    
    func sendString(_ message: String) {
        webSocket?.send(URLSessionWebSocketTask.Message.string(message)) { error in
            if let error = error {
                print("[SocketNetworkService] SendString failed with error \(error.localizedDescription)")
            }
        }
    }
    
    func sendData(_ data: Data) {
        webSocket?.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                print("[SocketNetworkService] SendData failed with error \(error.localizedDescription)")
            }
        }
    }
    
    func receiveMessage() {

        if !isConnectionOpen {
            openWebSocket()
        }

        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let messageString):
                    print("[Client] Received string: \(messageString)")
                case .data(let data):
                    print("[Client] Received data: \(data.description)")
                default:
                    print("Unknown type received from WebSocket")
                }
            }
            self?.receiveMessage()
        })
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
