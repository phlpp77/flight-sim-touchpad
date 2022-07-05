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
}

enum Screen: String, CaseIterable, Identifiable {
    case essential
    case additional
    var id: Self { self }
}

enum IPConfig: String, CaseIterable, Identifiable {
    case lab = "192.168.103.103"
    case localhost = "localhost"
    var id: Self { self }
}
