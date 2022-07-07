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
}

enum Screen: String, CaseIterable, Identifiable {
    case essential
    case additional
    var id: Self { self }
}

enum IPConfig: Hashable, CaseIterable, Identifiable {
//    var id: ObjectIdentifier
    
    static var allCases: [IPConfig] = [.lab, .localhost, .custom("")]
    
    case lab
    case localhost
    case custom(String)
    
    var ip: String {
        switch self {
        case .lab:
            return "192.168.103.103"
        case .localhost:
            return "localhost"
        case .custom(let customValue):
            return customValue
        }
    }
    
    var id: Self.ID { self.id }
}
