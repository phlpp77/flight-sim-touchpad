//
//  GearRangeView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 16.06.22.
//

import SwiftUI

struct GearRangeView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("UP")
                    .frame(height: 1)
            }
            
            Spacer(minLength: 0)
            
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("DOWN")
                    .frame(height: 1)
            }
            
        }
        .frame(width: 100, height: 500)
        
    }
}

struct GearRangeView_Previews: PreviewProvider {
    static var previews: some View {
        GearRangeView()
    }
}
