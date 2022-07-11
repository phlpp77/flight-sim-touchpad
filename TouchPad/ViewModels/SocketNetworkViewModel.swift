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
    
    // Open the connection to the MQTT server if not already connected
    func openConnection() {
        if !connectionOpen {
            webSocketService.openWebSocket()
        }
    }
    
    func changeValue(of name: AircraftDataType, to value: Int) {
        switch name {
        case .speed:
            webSocketService.changeSpeed(value)
        case .altitude:
            webSocketService.changeAltitude(value)
        case .heading:
            print("Case \(name) not handled here")
        case .flaps:
            switch value {
            case 0:
                webSocketService.changeFlaps(0)
            case 1:
                webSocketService.changeFlaps(4095)
            case 2:
                webSocketService.changeFlaps(8192)
            case 3:
                webSocketService.changeFlaps(12287)
            case 4:
                webSocketService.changeFlaps(16383)
            default:
                webSocketService.changeFlaps(0)
            }
        case .gear:
            switch value {
            case 0:
                webSocketService.changeGear(0)
            case 1:
                webSocketService.changeGear(16383)
            default:
                webSocketService.changeGear(0)
            }
        case .spoiler:
            webSocketService.changeSpoiler(value)
        case .verticalSpeed:
            webSocketService.changeVerticalSpeed(value)
        case .navZoomFactor:
            webSocketService.changeNavZoomFactor(value)
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
