//
//  TouchPadApp.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.03.22.
//

import SwiftUI

@main
struct TouchPadApp: App {
    
    @StateObject var appearanceVM = AppearanceViewModel()
    let touchPadModel = TouchPadModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(appearanceVM: appearanceVM)
                .preferredColorScheme(.dark)
//                .environmentObject(appearanceVM)
                .onAppear {
                    appearanceVM.model = touchPadModel
                }
        }
    }
}
