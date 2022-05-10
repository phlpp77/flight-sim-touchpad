//
//  SpeedSliderView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 09.05.22.
//

import SwiftUI

struct SpeedSliderView: View {
    
    var range = 1...4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            ForEach(range.reversed(), id: \.self) { item in
                VStack(alignment: .leading, spacing: 2.0) {
                    HStack {
                        Rectangle()
                            .frame(width: 18, height: 1)
                        Text("\(item)00")
                            .frame(height: 1)
                    }
                    VStack(alignment: .leading, spacing: 2.0) {
                            ForEach(1...9, id: \.self) { _ in
                                Rectangle()
                                    .frame(width: 8, height: 1)
                            }
                        HStack {
                            Rectangle()
                                .frame(width: 18, height: 1)
                            Text("\(item - 1)50")
                                .frame(height: 1)
                        }
                            ForEach(1...9, id: \.self) { _ in
                                Rectangle()
                                    .frame(width: 8, height: 1)
                            }
                        }
                    }
                    }
                }
            }
        }
   

struct SpeedSliderView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedSliderView()
    }
}
