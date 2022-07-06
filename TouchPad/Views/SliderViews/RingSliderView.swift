//
//  RingSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 04.05.22.
//

import SwiftUI
import simd
import AudioToolbox

struct RingSliderView: View {
    
    @EnvironmentObject var socketNetworkVM: SocketNetworkViewModel
    @EnvironmentObject var mqttNetworkVM: MQTTNetworkViewModel
    @EnvironmentObject var appearanceVM: AppearanceViewModel
    @EnvironmentObject var ringSliderVM: RingSliderViewModel
    @Binding var turnFactor: Int
    
    var circleDiameter: CGFloat = 75
    var showMarker: Bool = false
    
    @Binding var progress: CGFloat
    @Binding var oldProgress: CGFloat
    @Binding var degrees: Double
    @Binding var oldDegrees: Double
    @Binding var startTrim: CGFloat
    @Binding var endTrim: CGFloat
    @Binding var startAngle: Double
    @State private var globalPos: CGPoint = .zero
    
    @State private var markerPos: CGPoint = .zero
    
    @State private var vStart: SIMD2<Double> = .zero
    @State private var isDragging: Bool = false
    @State private var relativeDeviation: CGPoint = .zero
    
    @State private var firstMovement = true
    @State private var startTimeStamp = Date().localFlightSim()
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                
                ZStack {
                    Text(degrees < 100 ? (degrees < 10 ? "00\(Int(degrees))°" : "0\(Int(degrees))°") : "\(Int(degrees))°")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .center)
                        .offset(y: -170)
                    
                    Circle()
                        .trim(from: startTrim, to: endTrim)
                        .stroke(style: StrokeStyle(lineWidth: 34, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(startAngle))
                        .foregroundColor(Color(hexCode: "FFF000")!)
                        .opacity(0.6)
                    
                    GeometryReader { geoKnob in
                        Image("Knob")
                            .resizable()
                            .shadow(color: Color(hexCode: "4D4D4D")!, radius: 10, x: -3, y: -4)
                            .shadow(color: progress > 0.95 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                            .gesture(
                                DragGesture(coordinateSpace: .named("RingSlider"))
                                    .onChanged { actions in
                                        
                                        // Only executed after the touchdown
                                        if firstMovement {
                                            // get start time of movement
                                            startTimeStamp = Date().localFlightSim()
                                            
                                            // get global coordinates of starting point
                                            let gGlobal = geoKnob.frame(in: .global)
                                            globalPos = gGlobal.origin
                                            globalPos.x = round(globalPos.x * 10) / 10
                                            globalPos.y = round(globalPos.y * 10) / 10
                                            
                                            oldProgress = progress
                                            startAngle = degrees
                                            firstMovement = false
                                            
                                            // MARK: Save touch down to log
                                            print("heading slider started dragging at \(Date().localFlightSim())")
                                            let logData = LogData(attribute: "heading", startTime: Date().localFlightSim(), endTime: Date().localFlightSim(), extra: "Touch down")
                                            log.append(logData)
                                            if mqttNetworkVM.connectionOpen {
                                                mqttNetworkVM.sendToLog(logData)
                                            }
                                        }
                                        
                                        // create vectors
                                        let center = SIMD2<Double>(x: geo.size.width / 2, y: geo.size.height / 2)
                                        let intersection = SIMD2<Double>(x: actions.location.x, y: actions.location.y)
                                        
                                        // every time a new drag starts the start-point is reseted
                                        if !isDragging {
                                            startInteraction(intersection: intersection, center: center)
                                        } else {
                                            changeInteraction(intersection: intersection, center: center)
                                        }
                                        
                                        isDragging = true
                                        
                                        // position of marker
                                        markerPos = actions.location
                                        markerPos.y -= geo.size.width / 2
                                        markerPos.x -= geo.size.height / 2
                                        
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        print("heading set from: \(oldDegrees) to \(degrees) with turn-factor \(turnFactor) and with a relative deviation \(relativeDeviation) on global Position \(globalPos) at \(Date().localFlightSim())")
                                        
                                        // MARK: Save to log
                                        // Create Log component
                                        let logData = LogData(attribute: "heading", oldValue: oldDegrees, value: degrees, relativeDeviation: relativeDeviation, globalCoordinates: globalPos, startTime: startTimeStamp, endTime: Date().localFlightSim(), extra: String(turnFactor))
                                        // Add to local log on iPad
                                        log.append(logData)
                                        // Add to remote log via MQTT
                                        if mqttNetworkVM.connectionOpen {
                                            mqttNetworkVM.sendToLog(logData)
                                        }
                                        
                                        // MARK: Update values
                                        // Update local value on state
                                        ringSliderVM.changeValue(to: Int(degrees))
                                        // Update remote value via WebSocket
                                        if socketNetworkVM.offsetsDeclared {
                                            socketNetworkVM.changeHeading(Int(degrees), turnFactor: turnFactor)
                                        }
                                        
                                        firstMovement = true
                                        oldDegrees = degrees
                                    }
                                
                            )
                            .simultaneousGesture(
                                DragGesture(coordinateSpace: .named("Circle"))
                                    .onChanged { actions in
                                        relativeDeviation = actions.startLocation
                                        relativeDeviation.x -= circleDiameter / 2
                                        relativeDeviation.y -= circleDiameter / 2
                                        relativeDeviation.x = round(relativeDeviation.x * 10) / 10.0
                                        relativeDeviation.y = round(relativeDeviation.y * 10) / 10.0
                                        
                                    }
                            )
                    }
                    .frame(width: circleDiameter, height: circleDiameter)
                    .coordinateSpace(name: "Circle")
                    .offset(y: -geo.size.width / 2)
                    .rotationEffect(Angle.degrees(360 * Double(progress)))
                    .onChange(of: degrees) { _ in
                        if appearanceVM.sliderSoundEffect {
                            AudioServicesPlaySystemSound(1104)
                        }
                    }
                }
            }
            .coordinateSpace(name: "RingSlider")
            .aspectRatio(contentMode: .fit)
            
            // MARK: Marker
            if appearanceVM.showTapIndicator {
                Rectangle()
                    .fill(.blue)
                    .position(markerPos)
                    .frame(width: 20, height: 20)
                    .gesture(
                        DragGesture()
                            .onChanged { actions in
                                markerPos = actions.location
                            }
                    )
            }
        }
    }
    
    
    /// Initialize the the angle calculation
    func startInteraction(intersection: SIMD2<Double>, center: SIMD2<Double>) {
        vStart = normalize(intersection - center)
    }
    
    /// Fulfill and update the angle calculation
    func changeInteraction(intersection: SIMD2<Double>, center: SIMD2<Double>) {
        let vEnd = normalize(intersection - center)
        let d = simd_clamp(dot(vStart, vEnd), -1.0, 1.0)
        var angle = cross(vStart, vEnd).z > 0 ? acos(d) : -acos(d)
        angle /= 2 * Double.pi
        progress += angle
        
        // MARK: Only one turn is allowed (resets to 0 after a full circle)
        if progress > 1 {
            progress -= 1
        } else if progress < 0 {
            progress += 1
        }
        
        calculateIndicatorLine()
        
        var localDegrees = simd_clamp(round(Double(progress) * 360), -360, 360)
        // round to every 5
        if appearanceVM.headingStepsInFive {
            localDegrees = round(localDegrees / 5) * 5
        }
        degrees = localDegrees
        vStart = vEnd
    }
    
    // MARK: Calculation of indicator line
    func calculateIndicatorLine() {
        var trim: CGFloat = .zero
        // turn right
        if turnFactor == 1 {
            // turn over 0 value
            if progress < oldProgress {
                trim = 1 - oldProgress + progress
            }
            // no turn over 0 value
            else {
                trim = oldProgress - progress
            }
            startTrim = 0
            endTrim = abs(trim)
        }
        // turn left
        else {
            
            // turn over 0 value
            if progress > oldProgress {
                trim = oldProgress + 1 - progress
            }
            // no turn over 0 value
            else {
                trim = oldProgress - progress
            }
            startTrim = 1 - abs(trim)
            endTrim = 1
        }
    }
    
}

//struct RingSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        let socketNetworkVM = SocketNetworkViewModel()
//        let mqttNetworkVM = MQTTNetworkViewModel()
//
//        RingSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, turnFactor: .constant(-1), progress: .constant(.zero), degrees: .constant(0))
//            .previewDevice("iPad Pro (11-inch) (3rd generation)")
//    }
//}
