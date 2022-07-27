//
//  StateValuesTestView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 29.06.22.
//

import SwiftUI

struct StateValuesTestView: View {
    
    @EnvironmentObject var stateValuesTestVM: StateValuesTestViewModel
    
    var body: some View {
        
        // MARK: Show all values that are saved inside the Model/State
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("show tap indicator: \(String(stateValuesTestVM.showTapIndicator))")
                    Text("speed steps in five: \(String(stateValuesTestVM.speedStepsInFive))")
                    Text("heading steps in five: \(String(stateValuesTestVM.headingStepsInFive))")
                    Text("screen selected: \(stateValuesTestVM.screen.rawValue)")
                    Text("sound effects on: \(String(stateValuesTestVM.sliderSoundEffect))")
                }
                VStack(alignment: .leading) {
                    Text("speed: \(stateValuesTestVM.speed)")
                    Text("heading: \(stateValuesTestVM.heading)")
                    Text("altitude: \(stateValuesTestVM.altitude)")
                    Text("flaps: \(stateValuesTestVM.flaps)")
                    Text("gear: \(stateValuesTestVM.gear)")
                    Text("spoiler: \(stateValuesTestVM.spoiler)")
                }
            }
            
            // MARK: Refresh view to get the current state
            Button {
                stateValuesTestVM.updateData()
            } label: {
                Image(systemName: "arrow.clockwise.circle")
                    .font(.largeTitle)
            }
        }
        .padding(4)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StateValuesTestView_Previews: PreviewProvider {
    static var previews: some View {
        StateValuesTestView()
    }
}
