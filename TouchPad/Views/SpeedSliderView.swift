//
//  SpeedSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 10.05.22.
//


import SwiftUI
import Sliders
import simd

struct SpeedSliderView: View {
    
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    @ObservedObject var appearanceVM: AppearanceViewModel
    
    var thumbWidth: CGFloat = 80
    var thumbHeight: CGFloat = 30
    var step: Int = 1
    
    let minValue: Int
    let maxValue: Int
    let valueName: String
    
    @State private var value = 250
    @State private var oldValue = 250
    @State private var isEditing = false
    @State private var pos = CGPoint(x: 0, y: 0)
    @State private var thumbPos = CGPoint(x: 0, y: 0)
    @State private var livePos = CGPoint(x: 0, y: 0)
    @State private var relativeDeviation = CGPoint(x: 0, y: 0)
    
    @State private var firstMovement = true
    @State private var startTimeStamp = Date().localFlightSim()
    
    
    var body: some View {
                    
            ZStack {
                
                HStack {
                    ValueSlider(value: $value, in: minValue...maxValue, step: step, onEditingChanged: {editing, values in
                        pos = values.startLocation
                        livePos = values.location
                        print(value)
                        print((value * 7/3)-100)
                        
                        if firstMovement {
                            startTimeStamp = Date().localFlightSim()
                            firstMovement = false
                        }
                        if !editing {
                            print("\(valueName) set from: \(oldValue) to \(value) with relative deviation \(relativeDeviation) started at \(startTimeStamp) until \(Date().localFlightSim())")
                            // MARK: Save to log
                            log.append(LogData(attribute: valueName, oldValue: Double(oldValue), value: Double(value), relativeDeviation: relativeDeviation, startTime: startTimeStamp, endTime: Date().localFlightSim()))
                            if socketNetworkVM.offsetsDeclared {
                                socketNetworkVM.changeValue(of: valueName, to: value)
                            }
                            oldValue = value
                            firstMovement = true
                            
                        }
                    })
                    .valueSliderStyle(
                        VerticalValueSliderStyle(
                            track:
                                VerticalValueTrack(
                                    view: RoundedRectangle(cornerRadius: 0)
                                        .opacity(0.4)
                                        .allowsHitTesting(false),
                                    mask: RoundedRectangle(cornerRadius: 0)
                                ),
                            thumb:
                                ZStack {
                                    GeometryReader { geo in
                                        Rectangle()
                                            .onChange(of: pos) { _ in
                                                let g = geo.frame(in: .named("slider"))
                                                thumbPos = g.origin
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
                    
                    ZStack {
                        if valueName == "speed" {
                            RangeView()
                        } else if valueName == "altitude" {
                            AltitudeRangeView()
                        }
                        
                        ThumbView(value: $value, unit: valueName == "speed" ? "kt" : "ft")
//                            .offset(y: simd_clamp(livePos.y, 0, 700) - 350)
                            .offset(y: CGPoint(x: 0, y: (value * -7/3)-100).y + 700)
                    }
                }
                
                
                // MARK: Show positions
                
                // Position of startTap location
                if appearanceVM.showTapIndicator {
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
            .frame(width: 200, height: 700)
            .padding()
        
    }
}


struct SpeedSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        let appearanceVM = AppearanceViewModel()
        SpeedSliderView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM, minValue: 100, maxValue: 399, valueName: "speed")
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
