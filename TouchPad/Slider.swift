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
    @State private var pos = CGPoint(x: 0, y: 0)
    @State private var thumbPos = CGPoint(x: 0, y: 0)
    
    var body: some View {
        ZStack {
            VStack {
//                Text("Speed \(speed)")
//                    .font(.largeTitle)
                
                ValueSlider(value: $speed, in: 100...399, step: 1, onEditingChanged: {editing, values in
                    print("end editing: \(editing) start loc: \(values)")
                    pos = values.location
                    pos.x += 200
                    print("thumb pos: \(thumbPos)")
                    if !editing {
    //                    socketNetworkVM.setSpeed(to: speed)
                    }
                })
                .valueSliderStyle(

                    VerticalValueSliderStyle(
                        track: VerticalValueTrack(view: RoundedRectangle(cornerRadius: 40), mask: RoundedRectangle(cornerRadius: 12)),
                        thumb:
                            GeometryReader { geo in
                                Rectangle()
                                .frame(width: 150, height: 80, alignment: .leading)
                                .foregroundColor(.gray)
                                .mask(RoundedRectangle(cornerRadius: 12))
                            }
                            
                    )
                )
            }
            .frame(width: 200)
        }
        Rectangle()
            .foregroundColor(.red)
            .frame(width: 20, height: 20)
            .position(pos)
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        SliderView(socketNetworkVM: socketNetworkVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
