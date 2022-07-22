//
//  AppearanceSettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 19.07.22.
//

import SwiftUI

struct AppearanceSettingsView: View {
    
    @EnvironmentObject var appearanceVM: AppearanceViewModel
    
    var body: some View {
        Form {
            // MARK: Show tap indicators
            Toggle(isOn: $appearanceVM.toggleShowTapIndicator) {
                Text("Show tap indicators")
            }
            
            // MARK: Show test value window
            Toggle(isOn: $appearanceVM.toggleShowTestValueWindow) {
                Text("Show values in state")
            }
            
            // MARK: Toggle slider sound effect
            Toggle(isOn: $appearanceVM.toggleSliderSoundEffect) {
                Text("\(appearanceVM.sliderSoundEffect ? "Disable" : "Enable") sound effects of sliders")
            }
            
            // MARK: Lock the speed every five steps
            Toggle(isOn: $appearanceVM.toggleSpeedStepsInFive) {
                Text("Lock speed every 10 steps")
            }
            
            // MARK: Lock the heading every five steps
            Toggle(isOn: $appearanceVM.toggleHeadingStepsInFive) {
                Text("Lock heading every five steps")
            }
        }
        .font(.body)
    }
}

struct AppearanceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettingsView()
    }
}
