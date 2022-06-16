//
//  FlapsRangeView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 16.06.22.
//


import SwiftUI

struct FlapsRangeView: View {
    
    var range = 0...3
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            ForEach(range, id: \.self) { item in
                
                HStack {
                    Rectangle()
                        .frame(width: 18, height: 1)
                    Text("\(item)")
                        .frame(height: 1)
                }
                Spacer(minLength: 0)
            }
            
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("FULL")
                    .frame(height: 1)
            }
            
            
        }
        .frame(width: 100, height: 500)
        
    }
}


struct FlapsView_Previews: PreviewProvider {
    static var previews: some View {
        FlapsRangeView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
