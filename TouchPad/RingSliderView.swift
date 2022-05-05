//
//  RingSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 04.05.22.
//

import SwiftUI

struct RingSliderView: View {
    
    var circleDiameter: CGFloat = 50
    
    @State private var progress: CGFloat = 0.0
    @State private var markerPos: CGPoint = .zero
    
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
                                
                                markerPos = actions.location
                                markerPos.y -= geo.size.width / 2
                                markerPos.x -= geo.size.height / 2
                                print("marker pos x: \(markerPos.x / geo.size.width * 2)")
                                print("marker pos y: \(markerPos.y / geo.size.width * 2)")
                                
                                
                                var localCoords = actions.location
                                localCoords.y -= geo.size.width / 2
                                localCoords.x -= geo.size.height / 2
                                localCoords.x = localCoords.x / geo.size.width * 2
                                localCoords.y = localCoords.y / geo.size.height * 2
                                
                                // change coordinate system from standard unit circle to swiftUI
                                localCoords.y *= -1
                                
                                print("local cords: \(localCoords)")
                                let degree = coord2degree(localCoords)
                                print("degree: \(degree / 360)")
                                progress = degree / 360 <= 0.99 ? CGFloat(degree / 360) : 1
                                
                                
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
    
    func coord2degree(_ coord: CGPoint) -> Double {
        if coord.x <= 1 && coord.y <= 1 {
            var xValue = abs(rad2deg(asin(Double(coord.x))))
            let yValue = abs(rad2deg(acos(Double(coord.y))))
            print("values: \(xValue), \(yValue)")
            if coord.x < 0 {
                xValue += 180
            }
            
            print("values: \(xValue), \(yValue)")
            
            //            return 1
            return max(xValue, yValue)
        } else {
            return 0.0
        }
    }
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
}

struct RingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        RingSliderView()
    }
}
