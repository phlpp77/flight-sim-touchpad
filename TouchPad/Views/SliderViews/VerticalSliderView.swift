//
//  VerticalSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 10.05.22.
//


import SwiftUI
import Sliders

struct VerticalSliderView: View {
    
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    @ObservedObject var mqttNetworkVM: MQTTNetworkViewModel
    @ObservedObject var appearanceVM: AppearanceViewModel
    
    var topToBottom: Bool = false
    var step: Int = 1
    
    let minValue: Int
    let maxValue: Int
    let aircraftData: AircraftDataType
    let thumbWidth: CGFloat = 50
    let thumbHeight: CGFloat = 50
    
    
    @State private var value = 250
    @State private var oldValue = 250
    @State private var stringValue = "250"
    @State private var isEditing = false
    @State private var pos = CGPoint(x: 0, y: 0)
    @State private var thumbPos = CGPoint(x: 0, y: 0)
    @State private var relativeDeviation = CGPoint(x: 0, y: 0)
    @State private var globalPos: CGPoint = .zero
    
    @State private var firstMovement = true
    @State private var startTimeStamp = Date().localFlightSim()
    
    
    var body: some View {
        
        ZStack {
            
            HStack {
                ZStack {
                    Image("Slider-Bar")
                        .resizable()
                        .allowsHitTesting(false)
                        .frame(width: 120, height: 820)
                    
                    ValueSlider(value: $value, in: minValue...maxValue, step: step, onEditingChanged: {editing, values in
                        pos = values.startLocation
                        
                        if firstMovement {
                            startTimeStamp = Date().localFlightSim()
                            firstMovement = false
                        }
                        
                        // check for special values
                        switch aircraftData {
                        case .flaps:
                            if value == 4 {
                                stringValue = "FULL"
                            } else {
                                stringValue = String(value)
                            }
                        case .gear:
                            if value == 0 {
                                stringValue = "UP"
                            } else {
                                stringValue = "DOWN"
                            }
//                        case .spoiler:
//                            <#code#>
                        default:
                            stringValue = String(value)
                        }
        
                        
                        if !editing {
                            print("\(aircraftData.rawValue) set from: \(oldValue) to \(value) with relative deviation \(relativeDeviation) on global Position \(globalPos) started at \(startTimeStamp) until \(Date().localFlightSim())")
                            // MARK: Save to log
                            let logData = LogData(attribute: String(aircraftData.rawValue), oldValue: Double(oldValue), value: Double(value), relativeDeviation: relativeDeviation, globalCoordinates: globalPos, startTime: startTimeStamp, endTime: Date().localFlightSim())
                            log.append(logData)
                            if socketNetworkVM.offsetsDeclared {
                                socketNetworkVM.changeValue(of: aircraftData, to: value)
                            }
                            if mqttNetworkVM.connectionOpen {
                                mqttNetworkVM.sendToLog(logData)
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
                                            .opacity(0.6)
                                        Spacer()
                                    }
                                        .allowsHitTesting(false),
                                    mask: Capsule()
                                        .allowsHitTesting(false)
                                ),
                            thumb:
                                ZStack {
                                    GeometryReader { geo in
                                        Image("Knob")
                                            .resizable()
                                            .onChange(of: pos) { _ in
                                                let g = geo.frame(in: .named("slider"))
                                                thumbPos = g.origin
                                                thumbPos.x += thumbWidth / 2
                                                thumbPos.y += thumbHeight / 2
                                                relativeDeviation.x = pos.x - thumbPos.x
                                                relativeDeviation.y = pos.y - thumbPos.y
                                                relativeDeviation.y = round(relativeDeviation.y * 10) / 10
                                                
                                                let gGlobal = geo.frame(in: .global)
                                                globalPos = gGlobal.origin
                                                globalPos.y = round(globalPos.y * 10) / 10
                                            }
                                    }
                                    .frame(width: thumbWidth, height: thumbHeight)
                                }
                        )
                    )
                    
                    .coordinateSpace(name: "slider")
                    .rotationEffect(Angle.degrees(topToBottom ? 180 : 0))
                    .frame(width: 120, height: 540)
                }
                
                ZStack {
                    
                    // MARK: Value range and Value indicator
                    switch aircraftData {
                    case .speed:
                        SpeedRangeView()
                        ThumbView(value: $stringValue, unit: "kt")
                            .offset(y: CGFloat((700*(400-value))/300 - 350))
                    case .altitude:
                        AltitudeRangeView()
                        ThumbView(value: $stringValue, unit: "ft")
                            .offset(y: CGFloat((700*(20000-value))/19900 - 350))
                    case .flaps:
                        FlapsRangeView()
                        ThumbView(value: $stringValue, unit: "")
                            .offset(y: CGFloat(-(500*(4-value))/4 + 250))
                    case .gear:
                        GearRangeView()
                        ThumbView(value: $stringValue, unit: "")
                            .offset(y: CGFloat(value == 0 ? -250 : 250))
                        //                    case .spoiler: break
                        //                        //
                    default:
                        EmptyView()
                    }
                    
                    
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
        .onAppear {
            // set initial values
            switch aircraftData {
            case .speed:
                value = 250
                oldValue = 250
                stringValue = "250"
            case .altitude:
                value = 10000
                oldValue = 10000
                stringValue = "10000"
            case .heading: break
                //
            case .flaps:
                value = 0
                oldValue = 0
                stringValue = "0"
            case .gear:
                value = 0
                oldValue = 0
                stringValue = "UP"
            case .spoiler: break
                //
            }
        }
    }
}


struct SpeedSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        let appearanceVM = AppearanceViewModel()
        let mqttNetworkWM = MQTTNetworkViewModel()
        VerticalSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkWM, appearanceVM: appearanceVM, minValue: 100, maxValue: 399, aircraftData: .speed)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
