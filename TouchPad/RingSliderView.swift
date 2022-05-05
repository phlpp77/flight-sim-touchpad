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
    
    @State private var progress: CGFloat = 0.0
    @State private var markerPos: CGPoint = .zero
    
    @State private var vStart: SIMD2<Double> = .zero
    @State private var isDragging: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .shadow(color: progress > 0.95 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                    .gesture(
                        DragGesture(coordinateSpace: .named("RingSlider"))
                            .onChanged { actions in
                                
//                                var center: CGPoint = .zero
//                                center.y -= geo.size.width / 2
//                                center.x -= geo.size.height / 2
                                
                                let center = SIMD2<Double>(x: geo.size.width / 2, y: geo.size.height / 2)
                                let intersection = SIMD2<Double>(x: actions.location.x, y: actions.location.y)
                                
                                print("center and intersec: \(center) \(intersection)")
                                
                                if !isDragging {
                                    startInteraction(intersection: intersection, center: center)
                                } else {
                                    changeInteraction(intersection: intersection, center: center)
                                }
                                
                                isDragging = true
                                
                                
                                markerPos = actions.location
                                markerPos.y -= geo.size.width / 2
                                markerPos.x -= geo.size.height / 2
                                
                                
                                
                                
//                                print("marker pos x: \(markerPos.x / geo.size.width * 2)")
//                                print("marker pos y: \(markerPos.y / geo.size.width * 2)")
                                
                                
//                                var localCoords = actions.location
//                                localCoords.y -= geo.size.width / 2
//                                localCoords.x -= geo.size.height / 2
//                                localCoords.x = localCoords.x / geo.size.width * 2
//                                localCoords.y = localCoords.y / geo.size.height * 2
//
//                                // change coordinate system from standard unit circle to swiftUI
//                                localCoords.y *= -1
//
//                                print("local cords: \(localCoords)")
//                                let degree = coord2degree(localCoords)
//                                print("degree: \(degree / 360)")
//                                progress = degree / 360 <= 0.99 ? CGFloat(degree / 360) : 1
                                
                                
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                            
                    )
                    .simultaneousGesture(
                        DragGesture(coordinateSpace: .named("Circle"))
                            .onChanged { actions in
                                var relativeDeviation = actions.startLocation
                                relativeDeviation.x -= circleDiameter / 2
                                relativeDeviation.y -= circleDiameter / 2
                                
                                print("relative deviation: \(relativeDeviation)")
                            }
                    )
                    .coordinateSpace(name: "Circle")
                    .frame(width: circleDiameter, height: circleDiameter)
                    .offset(y: -geo.size.width / 2)
                    .rotationEffect(Angle.degrees(360 * Double(progress)))
                    
                
                
                Rectangle()
                    .fill(.green)
                    .position(markerPos)
                    .frame(width: 20, height: 20)
                    .gesture(
                        DragGesture()
                            .onChanged { actions in
                                markerPos = actions.location
                                print("marker pos x: \(markerPos.x / geo.size.width * 2)")
                            }
                    )
            }
        }
        .background(Color.red)
        .coordinateSpace(name: "RingSlider")
        
        .aspectRatio(contentMode: .fit)
        
        
    }
    
    
    /// start Interaction
    func startInteraction(intersection: SIMD2<Double>, center: SIMD2<Double>) {
        // `intersection`: momentane touch-position
        vStart = normalize(intersection - center)
    }

    func changeInteraction(intersection: SIMD2<Double>, center: SIMD2<Double>) {
        let vEnd = normalize(intersection - center)
        let d = simd_clamp(dot(vStart, vEnd), -1.0, 1.0)
        var angle = cross(vStart, vEnd).z > 0 ? acos(d) : -acos(d)
        angle /= 2 * Double.pi
        
        progress = simd_clamp(progress + angle, 0, 1)
//        progress += angle
        vStart = vEnd
        
//        let difference = angle - lastAngle
//        print(cross(vStart, vEnd))
//        progress += difference / (2 * Double.pi)
//        print("progress: \(progress) \(difference)")
//        lastAngle = angle

        // zielvariable um `difference` erhöhen
    }
    
}

struct RingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        RingSliderView()
    }
}
