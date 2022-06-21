//
//  TouchPadApp.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.03.22.
//

import SwiftUI

@main
struct TouchPadApp: App {
    
    let appearanceVM = AppearanceViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(appearanceVM: appearanceVM)
                .preferredColorScheme(.dark)
        }
    }
}
