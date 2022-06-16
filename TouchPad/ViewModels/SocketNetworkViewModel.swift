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
    @Published var offsetsDeclared = false
    
    init() {
        webSocketService.delegate = self
    }
    
    var toggleServerConnection: Bool = false {
        willSet {
            if newValue == true {
                if !connectionOpen {
                    webSocketService.openWebSocket()
                }
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
        } else if name == "flaps" {
            switch value {
            case 0:
                webSocketService.changeFlaps(0)
            case 1:
                webSocketService.changeFlaps(4095)
            case 2:
                webSocketService.changeFlaps(8191)
            case 3:
                webSocketService.changeFlaps(12287)
            case 4:
                webSocketService.changeFlaps(16383)
            default:
                webSocketService.changeFlaps(0)
            }
        }
    }
    
    func changeHeading(_ heading: Int, turnFactor: Int) {
        webSocketService.changeHeading(heading, turnFactor: turnFactor)
    }
    
}

extension SocketNetworkViewModel: SocketNetworkServiceDelegate {
    
    func didUpdateOffsetDeclare(declared: Bool) {
        DispatchQueue.main.async {
            self.offsetsDeclared = declared
        }
    }
    
    func didUpdateConnection(isOpen: Bool) {
        DispatchQueue.main.async {
            self.connectionOpen = isOpen
            self.toggleServerConnection = isOpen
            
            if !isOpen {
                self.offsetsDeclared = false
            }
        }
    }
}
