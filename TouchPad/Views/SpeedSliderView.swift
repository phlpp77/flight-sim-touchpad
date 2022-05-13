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
    
    var thumbWidth: CGFloat = 50
    var thumbHeight: CGFloat = 50
    var step: Int = 1
    
    let minValue: Int
    let maxValue: Int
    let valueName: String
    
    @State private var value = 250
    @State private var oldValue = 250
    @State private var isEditing = false
    @State private var pos = CGPoint(x: 0, y: 0)
    @State private var thumbPos = CGPoint(x: 0, y: 0)
    @State private var relativeDeviation = CGPoint(x: 0, y: 0)
    
    @State private var firstMovement = true
    @State private var startTimeStamp = Date().localFlightSim()
    
    
    var body: some View {
        
        ZStack {
            
            HStack {
                ZStack {
                    Image("Slider-Bar")
                        .resizable()
                        .frame(width: 120, height: 820)
                    
                    ValueSlider(value: $value, in: minValue...maxValue, step: step, onEditingChanged: {editing, values in
                        pos = values.startLocation
                        
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
                                    view: HStack {
                                        Spacer()
                                        Capsule()
                                            .frame(width: 34)
                                            .foregroundColor(Color(hexCode: "FFF000")!)
                                        Spacer()
                                    }
                                        .allowsHitTesting(false),
                                    mask: Capsule()
                                ),
                            thumb:
                                ZStack {
                                    GeometryReader { geo in
                                        Image("Knob")
                                            .resizable()
                                            .onChange(of: pos) { _ in
                                                let g = geo.frame(in: .named("slider"))
                                                print(g)
                                                thumbPos = g.origin
                                                thumbPos.x += thumbWidth / 2
                                                thumbPos.y += thumbHeight / 2
                                                relativeDeviation.x = pos.x - thumbPos.x
                                                relativeDeviation.y = pos.y - thumbPos.y
                                                relativeDeviation.y = round(relativeDeviation.y * 10) / 10
                                            }
                                    }
                                    .frame(width: thumbWidth, height: thumbHeight)
                                }
                        )
                    )
                    .coordinateSpace(name: "slider")
                    .frame(width: 120, height: 540)
                }
                
                ZStack {
                    
                    // MARK: Value range
                    if valueName == "speed" {
                        RangeView()
                    } else if valueName == "altitude" {
                        AltitudeRangeView()
                    }
                    
                    // MARK: Value indicator
                    ThumbView(value: $value, unit: valueName == "speed" ? "kt" : "ft")
                        .offset(y: valueName == "speed" ? CGPoint(x: 0, y: ((700*(400-value))/300)).y - 350 : CGPoint(x: 0, y: ((700*(20000-value))/19900)).y - 350)
                }
            }
            
            // MARK: Show positions
            if appearanceVM.showTapIndicator {
                ZStack {
                    // Position of startTap location
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
                .frame(height: 540)
            }
        }
        .frame(width: 200, height: 700)
        
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
