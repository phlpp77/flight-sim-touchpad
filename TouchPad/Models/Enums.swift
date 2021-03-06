//
//  Enums.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 16.06.22.
//

import Foundation

enum AircraftDataType: String {
    case speed
    case altitude
    case heading
    case flaps
    case gear
    case spoiler
    case verticalSpeed
    case navZoomFactor
}

enum AircraftStatesType: String {
    case masterWarn
    case masterCaution 
}

enum Screen: String, CaseIterable, Identifiable {
    case essential
    case additional
    var id: Self { self }
}

enum IPConfig: Hashable, CaseIterable, Identifiable {
    
    static var allCases: [IPConfig] = [.lab, .office, .localhost, .homeoffice, .custom("")]
    
    case lab
    case office
    case localhost
    case homeoffice
    case custom(String)
    
    var ip: String {
        switch self {
        case .lab:
            return "192.168.103.103"
        case .office:
            return "192.168.103.105"
        case .localhost:
            return "localhost"
        case .homeoffice:
            return "192.168.178.76"
        case .custom(let customValue):
            return customValue
        }
    }
    
    var name: String {
        switch self {
        case .lab:
            return "Lab"
        case .office:
            return "Office"
        case .localhost:
            return "Localhost"
        case .homeoffice:
            return "Homeoffice"
        case .custom(let customValue):
            return customValue
        }
    }
    
    var id: Self { self }
}
