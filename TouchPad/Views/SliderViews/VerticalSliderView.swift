//
//  VerticalSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 10.05.22.
//


import SwiftUI
import Sliders
import AudioToolbox

struct VerticalSliderView: View {
    
    @EnvironmentObject var socketNetworkVM: SocketNetworkViewModel
    @EnvironmentObject var mqttNetworkVM: MQTTNetworkViewModel
    @EnvironmentObject var appearanceVM: AppearanceViewModel
    @EnvironmentObject var verticalSliderVM: VerticalSliderViewModel
    
    // Configuration of sliders
    public var topToBottom: Bool = false
    public let step: Int = 1
    public let minValue: Int
    public let maxValue: Int
    public let aircraftData: AircraftDataType
    
    private let thumbWidth: CGFloat = 100
    private let thumbHeight: CGFloat = 100
    private let deviceName = UIDevice.modelName
    
    @Binding var value: Int
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
            VStack {
                if !deviceName.contains("12.9") {
                    Spacer(minLength: 50)
                }
                Text("\(aircraftData != .verticalSpeed ? aircraftData.rawValue : "Vertical Speed")")
                    .textCase(.uppercase)
                    .font(.title3)
                    .foregroundColor(.gray)
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
                                
                                // MARK: Save touch down to log
                                print("\(aircraftData.rawValue) slider started dragging at \(Date().localFlightSim())")
                                let logData = LogData(attribute: String(aircraftData.rawValue), startTime: Date().localFlightSim(), endTime: Date().localFlightSim(), extra: "Touch down")
                                log.append(logData)
                                if mqttNetworkVM.connectionOpen {
                                    mqttNetworkVM.sendToLog(logData)
                                }
                            }
                            
                            formatSpecialValues()
                            
                            if !editing {
                                print("\(aircraftData.rawValue) set from: \(oldValue) to \(value) with relative deviation \(relativeDeviation) on global Position \(globalPos) started at \(startTimeStamp) until \(Date().localFlightSim())")
                                
                                // MARK: Save to log
                                // Create Log component
                                var logData = LogData(attribute: String(aircraftData.rawValue), oldValue: Double(oldValue), value: Double(value), relativeDeviation: relativeDeviation, globalCoordinates: globalPos, startTime: startTimeStamp, endTime: Date().localFlightSim())
                                // Add to local log on iPad
                                log.append(logData)
                                // Add to remote log via MQTT
                                if mqttNetworkVM.connectionOpen {
                                    
                                    // Data divided by 100 needed for fs
                                    if aircraftData == .verticalSpeed {
                                        logData.value = logData.value / 100
                                        logData.oldValue = logData.oldValue / 100
                                    }
                                    
                                    mqttNetworkVM.sendToLog(logData)
                                }
                                
                                // MARK: Update values
                                // Update local value on state
                                verticalSliderVM.changeValue(of: aircraftData, to: value)
                                // Update remote value via WebSocket
                                if socketNetworkVM.offsetsDeclared {
                                    socketNetworkVM.changeValue(of: aircraftData, to: value)
                                }
                                
                                firstMovement = true
                                oldValue = value
                            }
                        })
                        .valueSliderStyle(
                            VerticalValueSliderStyle(
                                track:
                                    VerticalValueTrack(
                                        view:
                                            HStack {
                                                Spacer()
                                                Capsule()
                                                    .frame(width: 34)
                                                    .foregroundColor(Color(hexCode: "FFF000")!)
                                                    .opacity(aircraftData != .verticalSpeed ? 0.6 : 0)
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
                        case .spoiler:
                            SpoilerRangeView()
                            ThumbView(value: $stringValue, unit: "")
                                .offset(y: CGFloat(-(500*(100-value))/90)+250)
                        case .verticalSpeed:
                            VerticalSpeedRangeView()
                            ThumbView(value: $stringValue, unit: "ft/min")
                                .offset(x: 10, y: CGFloat((700*(5000-value))/10000)-350)
                        default:
                            EmptyView()
                        }
                        
                        
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
            case .spoiler:
                value = 10
                oldValue = 10
                stringValue = "RET"
            case .verticalSpeed:
                value = 0
                oldValue = 0
                stringValue = "0"
            case .navZoomFactor: break
                //
            }
        }
        .onChange(of: value) { _ in
            stringValue = String(value)
            formatSpecialValues()
            if appearanceVM.sliderSoundEffect {
                SoundService.shared.tockSound()
            }
        }
    }
    
    func formatSpecialValues() {
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
        case .spoiler:
            if value == 10 {
                stringValue = "RET"
            } else if value == 55 {
                stringValue = "1 / 2"
            } else if value == 100 {
                stringValue = "FULL"
            } else {
                stringValue = ""
            }
        default:
            stringValue = String(value)
        }
    }
}

