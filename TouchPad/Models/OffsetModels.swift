//
//  DataModels.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 26.04.22.
//

import Foundation

// Offsets struct which can be used on all offset types. Both Offsets itself and the OffsetType must be Encodable
struct Offsets<OffsetType: Encodable>: Encodable {
    var command: String
    var name: String
    var offsets: [OffsetType]
}

// Offset which is used to declare the offsets - only used to initialized the connection
struct DeclareOffset: Encodable {
    var name: String
    var address: Int
    var type: String
    var size: Int
}

// Offset which is used to write into the variables
struct WriteOffset: Encodable {
    var name: String
    var value: Int
}


struct OffsetsDeclare: Encodable {
    var command = "offsets.declare"
    var name = "OffsetsWrite"
    var offsets = [
        Offset(name: "speed", address: 16906, type: "int", size: 2),
        Offset(name: "altitude", address: 16908, type: "int", size: 2),
        Offset(name: "heading", address: 16910, type: "int", size: 2),
        Offset(name: "TurnFactor", address: 16912, type: "int", size: 1)
    ]
    
    struct Offset: Encodable {
        var name: String
        var address: Int
        var type: String
        var size: Int
    }
}

struct OffsetsWrite: Encodable {
    var command = "offsets.write"
    var name = "OffsetsWrite"
    var offsets = [
        Offset(name: "speed", value: 222)
    ]
    
    struct Offset: Encodable {
        var name: String
        var value: Int
    }
}
