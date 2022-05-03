//
//  DataExport.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 03.05.22.
//

import Foundation
import SwiftUI

struct LogData {
    var attribute: String
    var oldValue: Int
    var value: Int
    var relativeDeviation: CGPoint
    var time: String
    
}

var log: [LogData] = []

func createLogCSV(filename: String) {
    
    var csvString = "Attribute,Old value,New value,Relative deviation,Date and time \n"
    for component in log {
        
        let newLine = "\(component.attribute),\(component.oldValue),\(component.value),x: \(component.relativeDeviation.x); y: \(component.relativeDeviation.y),\(component.time)\n"
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
                } else {
                    try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                    print("[Filemanager] CSV created")
                }
        
        
        
    } catch {
        print("[Filemanager] Failed to create file with error \(error)")
    }
    
}
