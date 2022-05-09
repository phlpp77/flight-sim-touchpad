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
    
    var thumbWidth: CGFloat = 100
    var thumbHeight: CGFloat = 100
    
    let minValue: Int
    let maxValue: Int
    let valueName: String
    let showMarker: Bool = false
    
    @State private var value = 300
    @State private var oldValue = 300
    @State private var isEditing = false
    @State private var pos = CGPoint(x: 0, y: 0)
    @State private var thumbPos = CGPoint(x: 0, y: 0)
    @State private var relativeDeviation = CGPoint(x: 0, y: 0)
    
    
    var body: some View {
        
        VStack {
            Text("\(valueName) \(value)")
                .font(.largeTitle)
            
            ZStack {
                ValueSlider(value: $value, in: minValue...maxValue, step: 1, onEditingChanged: {editing, values in
                    pos = values.startLocation
                    if !editing {
                        print("\(valueName) set from: \(oldValue) to \(value) with relative deviation \(relativeDeviation) at \(Date().localFlightSim())")
                        // MARK: Save to log
                        log.append(LogData(attribute: valueName, oldValue: Double(oldValue), value: Double(value), relativeDeviation: relativeDeviation, time: Date().localFlightSim()))
                        socketNetworkVM.changeValue(of: valueName, to: value)
                        oldValue = value
                        
                    }
                })
                .valueSliderStyle(
                    VerticalValueSliderStyle(
                        track:
                            VerticalValueTrack(
                                view: RoundedRectangle(cornerRadius: 12),
                                mask: RoundedRectangle(cornerRadius: 12)
                            ),
                        thumb:
                            ZStack {
                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 12)
                                        .onChange(of: pos) { _ in
                                            let g = geo.frame(in: .named("slider"))
                                            thumbPos = g.origin
                                            //                                            print("g: \(g)")
                                            thumbPos.x += thumbWidth / 2
                                            thumbPos.y += thumbHeight / 2
                                            relativeDeviation.x = pos.x - thumbPos.x
                                            relativeDeviation.y = pos.y - thumbPos.y
                                            relativeDeviation.y = round(relativeDeviation.y * 10) / 10
                                            
                                        }
                                }
                                .frame(width: thumbWidth, height: thumbHeight, alignment: .leading)
                                .foregroundColor(.gray)
                            }
                    )
                )
                
                
                // MARK: Show positions
                
                // Position of startTap location
                if showMarker {
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20)
                        .position(pos)
                    
                    // Position of center of slider thumb
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: 20, height: 20)
                        .position(thumbPos)
                }
            }
            .coordinateSpace(name: "slider")
            .frame(width: 200)
        }
    }
}


struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        SliderView(socketNetworkVM: socketNetworkVM, minValue: 100, maxValue: 399, valueName: "speed")
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
