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
        VStack {
            HStack {
                VStack {
                    Text("show tap indicator: \(String(stateValuesTestVM.showTapIndicator))")
                    Text("speed steps in five: \(String(stateValuesTestVM.speedStepsInFive))")
                    Text("heading steps in five: \(String(stateValuesTestVM.headingStepsInFive))")
                    Text("screen selected: \(stateValuesTestVM.screen.rawValue)")
                    Text("sound effects on: \(String(stateValuesTestVM.sliderSoundEffect))")
                }
                VStack {
                    Text("speed: \(stateValuesTestVM.speed)")
                    Text("heading: \(stateValuesTestVM.heading)")
                    Text("altitude: \(stateValuesTestVM.altitude)")
                    Text("flaps: \(stateValuesTestVM.flaps)")
                    Text("gear: \(stateValuesTestVM.gear)")
                    Text("spoiler: \(stateValuesTestVM.spoiler)")
                }
            }
            Button {
                stateValuesTestVM.updateData()
            } label: {
                Image(systemName: "arrow.clockwise.circle")
                    .font(.largeTitle)
            }
        }
        .cornerRadius(12)
        .background(Color.gray)
    }
}

struct StateValuesTestView_Previews: PreviewProvider {
    static var previews: some View {
        StateValuesTestView()
    }
}
