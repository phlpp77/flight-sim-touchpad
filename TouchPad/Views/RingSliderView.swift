//
//  RingSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 04.05.22.
//

import SwiftUI
import simd

struct RingSliderView: View {
    
    var circleDiameter: CGFloat = 50
    var showMarker: Bool = false
    
    @State private var progress: CGFloat = .zero
    @State private var degrees: Double = .zero
    @State private var oldDegrees: Double = .zero
    @Binding var turnFactor: Int
    
    @State private var markerPos: CGPoint = .zero
    
    @State private var vStart: SIMD2<Double> = .zero
    @State private var isDragging: Bool = false
    @State private var relativeDeviation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Text("Heading: \(degrees)°")
                    .foregroundColor(.white)
                
                Circle()
                    .stroke(lineWidth: 12)
                    .foregroundColor(.white)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .shadow(color: progress > 0.95 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                    .foregroundColor(.gray)
                    .gesture(
                        DragGesture(coordinateSpace: .named("RingSlider"))
                            .onChanged { actions in
                                
                                // create vectors
                                let center = SIMD2<Double>(x: geo.size.width / 2, y: geo.size.height / 2)
                                let intersection = SIMD2<Double>(x: actions.location.x, y: actions.location.y)
                                
                                // every time a new drag starts the start-point is resetted
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
                                log.append(LogData(attribute: "heading", oldValue: oldDegrees, value: degrees, relativeDeviation: relativeDeviation, time: Date().localFlightSim(), extra: String(turnFactor)))
                                // TODO: WRITE DEGREE VALUE TO SIMULATOR
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
                    .coordinateSpace(name: "Circle")
                    .frame(width: circleDiameter, height: circleDiameter)
                    .offset(y: -geo.size.width / 2)
                    .rotationEffect(Angle.degrees(360 * Double(progress)))
                
                
                // MARK: Marker
                if showMarker {
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
        progress = simd_clamp(progress + angle, 0, 1)
        degrees = round(Double(progress) * 360 * 10) / 10.0
        vStart = vEnd
    }
    
}

struct RingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        RingSliderView(turnFactor: .constant(-1))
    }
}
