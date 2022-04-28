//
//  Slider.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 28.04.22.
//

import SwiftUI
import Sliders

struct SliderView: View {
    
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    
    @State private var speed = 300
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            Text("Speed \(speed)")
                .font(.largeTitle)
            
            ValueSlider(value: $speed, in: 100...399, step: 1, onEditingChanged: {editing in
                print("end editing: \(editing)")
                if !editing {
                    socketNetworkVM.setSpeed(to: speed)
                }
            })
            .valueSliderStyle(

                VerticalValueSliderStyle(
                    track: VerticalValueTrack(view: Rectangle(), mask: RoundedRectangle(cornerRadius: 12)),
//                    track: Rectangle().foregroundColor(.gray),
                    thumb: Rectangle()
                        .frame(width: 200, height: 80, alignment: .leading)
                        .foregroundColor(.gray)
                        .mask(RoundedRectangle(cornerRadius: 12))
                ))
        }
        .frame(width: 200)
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        SliderView(socketNetworkVM: socketNetworkVM)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
