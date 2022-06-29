//
//  TouchPadApp.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.03.22.
//

import SwiftUI

@main
struct TouchPadApp: App {
    
    
//    @StateObject private var model = TouchPadModel()
    
    var body: some Scene {
        WindowGroup {
            ViewModelConnector()
            
        }
    }
}
