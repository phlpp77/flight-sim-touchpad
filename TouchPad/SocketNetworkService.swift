//
//  TouchPadModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.04.22.
//

import Foundation

class SocketNetworkService: NSObject, URLSessionWebSocketDelegate {
    var webSocket: URLSessionWebSocketTask?
    var isOpened: Bool = false
    
    
    override init() {
        super.init()
//        let urlString = "wss://rtf.beta.getbux.com/subscriptions/me"
//        let urlString = "wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self"
        let urlString = "ws://localhost:3000"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            webSocket = session.webSocketTask(with: request)
        }
    }
    
    func openWebSocket() {
        webSocket?.resume()
    }
    
    func sendString(_ message: String) {
        webSocket?.send(URLSessionWebSocketTask.Message.string(message)) { error in
            if let error = error {
                print("SendString failed with error \(error.localizedDescription)")
            }
        }
    }
    
    func sendData(_ data: Data) {
        webSocket?.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                print("SendData failed with error \(error.localizedDescription)")
            }
        }
    }
    
    func receiveMessage() {

        if !isOpened {
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
        print("Web socket opened")
                isOpened = true
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket closed")
                isOpened = false
    }
}
