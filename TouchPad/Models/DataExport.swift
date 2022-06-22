//
//  DataExport.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 03.05.22.
//

import Foundation
import SwiftUI

struct LogData: Encodable {
    var attribute: String
    var oldValue: Double = 999999
    var value: Double = 999999
    var relativeDeviation: CGPoint = CGPoint(x: 999999, y: 999999)
    var globalCoordinates: CGPoint = CGPoint(x: 999999, y: 999999)
    var startTime: String
    var endTime: String
    var extra: String = ""
    
}

var log: [LogData] = []

func createLogCSV(filename: String, fileCreated: @escaping (Bool) -> Void) {
    
    var csvString = "Attribute,Old value,New value,Relative deviation x,Relative deviation y,Global Coordinate x, Global Coordinate y, Start timestamp,End timestamp,Extra information\n"
    for component in log {
        
        let newLine = "\(component.attribute),\(component.oldValue),\(component.value),\(component.relativeDeviation.x),\(component.relativeDeviation.y),\(component.globalCoordinates.x),\(component.globalCoordinates.y),\(component.startTime),\(component.endTime),\(component.extra)\n"
        csvString.append(newLine)
    }
    
    let fileName = "\(filename).csv"
    let fileManager = FileManager.default
    
    
    
    do {
        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent(fileName)
        let filePath = fileURL.path
        if fileManager.fileExists(atPath: filePath) {
            print("[Filemanager] CSV not created: Name already existed")
            fileCreated(false)
        } else {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("[Filemanager] CSV created")
            fileCreated(true)
        }
        
        
        
    } catch {
        print("[Filemanager] Failed to create file with error \(error)")
    }
    
}
