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
    
    var toggleServerConnection: Bool = false {
        willSet {
            if newValue == true {
                webSocketService.openWebSocket()
            } else {
                webSocketService.closeWebSocket()
            }
        }
    }
    
    func setSpeed(to speed: Int) {
        webSocketService.changeSpeed(speed)
    }
    
    // returns value of connection
//    var connectionStatus: String {
//        webSocketService.isConnectionOpen ? "Connected" : "Not connected"
//    }
    
//    var isConnectionOpen: Bool {
//        webSocketService.isConnectionOpen
//    }
}
