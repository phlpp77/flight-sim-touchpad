//
//  VerticalSpeedRangeView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 07.07.22.
//



import SwiftUI

struct VerticalSpeedRangeView: View {
    
    private let range = 1...5
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0.0) {
            
            range1
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("0")
                    .frame(height: 1)
            }
            range2
            
        }
        .frame(width: 100, height: 700)
        
    }
    
    var range1: some View {
        ForEach(range.reversed(), id: \.self) { item in
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: 0.0) {
                
                HStack {
                    Rectangle()
                        .frame(width: 18, height: 1)
                    Text("\(item)000")
                        .frame(height: 1)
                }
                
                VStack(alignment: .leading, spacing: 0.0) {
                    
                    ForEach(1...9, id: \.self) { _ in
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: 8, height: 1)
                    }
                    Spacer(minLength: 0)
                    HStack {
                        Rectangle()
                            .frame(width: 18, height: 1)
                        Text("\(item - 1)500")
                            .frame(height: 1)
                            .font(.caption)
                    }
                    
                    ForEach(1...9, id: \.self) { _ in
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: 8, height: 1)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        
    }
    
    var range2: some View {
        ForEach(range, id: \.self) { item in
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: 0.0) {
                
                VStack(alignment: .leading, spacing: 0.0) {
                    
                    ForEach(1...9, id: \.self) { _ in
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: 8, height: 1)
                    }
                    Spacer(minLength: 0)
                    HStack {
                        Rectangle()
                            .frame(width: 18, height: 1)
                        Text("-\(item - 1)500")
                            .frame(height: 1)
                            .font(.caption)
                    }
                    
                    ForEach(1...9, id: \.self) { _ in
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: 8, height: 1)
                    }
                    Spacer(minLength: 0)
                }
                
                HStack {
                    Rectangle()
                        .frame(width: 18, height: 1)
                    Text("-\(item)000")
                        .frame(height: 1)
                }
                
                
            }
        }
        
    }
    
}


struct VerticalRangeView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSpeedRangeView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
