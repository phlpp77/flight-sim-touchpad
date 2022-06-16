//
//  SpoilerRangeView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 16.06.22.
//

import SwiftUI

struct SpoilerRangeView: View {
    
    var range = 0...1
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("RET")
                    .frame(height: 1)
            }
            Spacer(minLength: 0)
            
            ForEach(range, id: \.self) { item in
                
                HStack {
                    Rectangle()
                        .frame(width: 18, height: 1)
                    Text("")
                        .frame(height: 1)
                }
                Spacer(minLength: 0)
            }
            
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("1 / 2")
                    .frame(height: 1)
            }
            Spacer(minLength: 0)
            
            ForEach(range, id: \.self) { item in
                
                HStack {
                    Rectangle()
                        .frame(width: 18, height: 1)
                    Text("")
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

struct SpoilerRangeView_Previews: PreviewProvider {
    static var previews: some View {
        SpoilerRangeView()
    }
}
