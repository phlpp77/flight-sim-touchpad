//
//  SocketNetworkViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.04.22.
//

import Foundation

class SocketNetworkViewModel: ObservableObject {
    
    // webSocketService to connect to web-socket
    @Published var webSocketService = SocketNetworkService()
    @Published var connectionOpen = false
    
    init() {
        webSocketService.delegate = self
    }
    
    var toggleServerConnection: Bool = false {
        willSet {
            if newValue == true {
                webSocketService.openWebSocket()
            } else {
                webSocketService.closeWebSocket()
            }
        }
    }
    
    func changeValue(of name: String, to value: Int) {
        if name == "speed" {
            webSocketService.changeSpeed(value)
        } else if name == "altitude" {
            webSocketService.changeAltitude(value)
        }
    }
    
    func changeHeading(_ heading: Int, turnFactor: Int) {
        webSocketService.changeHeading(heading, turnFactor: turnFactor)
    }
    
    // returns value of connection
//    var connectionStatus: String {
//        webSocketService.isConnectionOpen ? "Connected" : "Not connected"
//    }
    
//    var isConnectionOpen: Bool {
//        webSocketService.isConnectionOpen
//    }
}

extension SocketNetworkViewModel: SocketNetworkServiceDelegate {
    func didUpdateConnection(isOpen: Bool) {
        DispatchQueue.main.async {
            self.connectionOpen = isOpen
        }
    }
}
