//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @State var showLocation: Bool = false
    @State var showTapIndicator: Bool = false
    
    var body: some View {
        
        VStack {
            Text("Settings")
                .font(.largeTitle)
            List {
                Toggle(isOn: $showLocation) {
                    Text("Show location in Button")
                }
                Toggle(isOn: $showTapIndicator) {
                    Text("Show Tap-indicator")
                }
            }
        }
        .frame(width: 400, height: 200)
        
        
        
        .accessibilityLabel("Settings")
        
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
