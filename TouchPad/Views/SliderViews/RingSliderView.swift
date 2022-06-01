//
//  RingSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 04.05.22.
//

import SwiftUI
import simd

struct RingSliderView: View {
    
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    @ObservedObject var appearanceVM: AppearanceViewModel
    @Binding var turnFactor: Int
    
    var circleDiameter: CGFloat = 50
    var showMarker: Bool = false
    
    @State private var progress: CGFloat = .zero
    @State private var oldProgress: CGFloat = .zero
    @State private var degrees: Double = .zero
    @State private var oldDegrees: Double = .zero
    
    @State private var markerPos: CGPoint = .zero
    
    @State private var vStart: SIMD2<Double> = .zero
    @State private var isDragging: Bool = false
    @State private var relativeDeviation: CGPoint = .zero
    
    @State private var firstMovement = true
    @State private var startTimeStamp = Date().localFlightSim()
    
    var body: some View {
        GeometryReader { geo in
                
                ZStack {
                    Text(degrees < 100 ? (degrees < 10 ? "00\(Int(degrees))°" : "0\(Int(degrees))°") : "\(Int(degrees))°")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .center)
                    
                    Circle()
//                        .trim(from: oldProgress, to: progress)
                        .trim(from: turnFactor == 1 ? oldProgress : progress, to: turnFactor == 1 ? progress : oldProgress)
                        .stroke(style: StrokeStyle(lineWidth: 34, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(-10))
                        .foregroundColor(Color(hexCode: "FFF000")!)
                        .opacity(0.6)
                    
                    Image("Knob")
                        .resizable()
                        .shadow(color: Color(hexCode: "4D4D4D")!, radius: 10, x: -3, y: -4)
                        .shadow(color: progress > 0.95 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                        .gesture(
                            DragGesture(coordinateSpace: .named("RingSlider"))
                                .onChanged { actions in
                                    
                                    // get start time of movement
                                    if firstMovement {
                                        startTimeStamp = Date().localFlightSim()
                                        firstMovement = false
                                        print("progress: from \(oldProgress) to \(progress)")
                                        oldProgress = progress
                                    }
                                    
//                                    print(actions.location)
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
                                    print("Heading set from: \(oldDegrees) to \(degrees) with turn-factor \(turnFactor) and with a relative deviation \(relativeDeviation) at \(Date().localFlightSim())")
                                    // MARK: Save to log
                                    log.append(LogData(attribute: "heading", oldValue: oldDegrees, value: degrees, relativeDeviation: relativeDeviation, startTime: startTimeStamp, endTime: Date().localFlightSim(), extra: String(turnFactor)))
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
                        
                        .frame(width: circleDiameter, height: circleDiameter)
                        .coordinateSpace(name: "Circle")
                        .offset(y: -geo.size.width / 2)
                        .rotationEffect(Angle.degrees(360 * Double(progress)))
                    
                    
                    // MARK: Marker
                    if appearanceVM.showTapIndicator {
                        Rectangle()
                            .fill(.green)
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
        .coordinateSpace(name: "RingSlider")
        .aspectRatio(contentMode: .fit)
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
        // only take angles between 0 and 1
//        progress = simd_clamp(progress + angle, -1, 1)
        
        progress += angle
        
        if progress > 1 {
            progress -= 1
        } else if progress < 0 {
            progress += 1
        }
        degrees = simd_clamp(round(Double(progress) * 360 * 10) / 10.0, -360, 360)
        vStart = vEnd
    }
    
}

struct RingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        let appearanceVM = AppearanceViewModel()
        
        RingSliderView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM, turnFactor: .constant(-1))
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
