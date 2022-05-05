//
//  RingSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 04.05.22.
//

import SwiftUI

struct RingSliderView: View {
    
    @State var progress: CGFloat = 0.3
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Circle()
                    .frame(width: 40, height: 40)
    //                .foregroundColor(progress > 0.95 ? Color.lightRed: Color.lightRed.opacity(0))
                    .offset(y: -geo.size.width / 2)
                    .rotationEffect(Angle.degrees(360 * Double(progress)))
//                    .shadow(color: progress > 0.95 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged { actions in
                                print(actions)
//                                progress = actions.location.x
                            }
                    )
            }
        }
        
    }
}

struct RingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        RingSliderView()
    }
}
