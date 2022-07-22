//
//  AltitudeRangeView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 11.05.22.
//

import SwiftUI

struct AltitudeRangeView: View {
    
    var range = 1...20
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0.0) {
            
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
                        
                        ForEach(1...4, id: \.self) { _ in
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
                        
                        ForEach(1...4, id: \.self) { _ in
                            Spacer(minLength: 0)
                            Rectangle()
                                .frame(width: 8, height: 1)
                        }
                        Spacer(minLength: 0)
                    }
                }
                
            }
            HStack {
                Rectangle()
                    .frame(width: 18, height: 1)
                Text("100")
                    .frame(height: 1)
            }
        }
        .frame(width: 100, height: 700)
        
        
    }
}

struct AltitudeRangeView_Previews: PreviewProvider {
    static var previews: some View {
        AltitudeRangeView()
    }
}
