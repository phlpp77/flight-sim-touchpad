//
//  DataModels.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 26.04.22.
//

import Foundation

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




//offsets_declare = {
//                    "command": 'offsets.declare',
//                    "name": 'OffsetsWrite',
//                    "offsets": [
//                        { "name": 'speed', "address": 0x420A, "type": 'int', "size": 2 },
//                        { "name": 'altitude', "address": 0x420C, "type": 'int', "size": 2 },
//                        { "name": 'heading', "address": 0x420E, "type": 'int', "size": 2 },
//                        { "name": 'TurnFactor', "address": 0x4210, "type": 'int', "size": 1 },
//                    ]
//                    }
