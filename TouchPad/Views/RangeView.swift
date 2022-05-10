//
//  RangeView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 09.05.22.
//

import SwiftUI

struct RangeView: View {
    
    var range = 2...4
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ForEach(range.reversed(), id: \.self) { item in
                Spacer()
                VStack(alignment: .leading) {
                    
                    HStack {
                        Rectangle()
                            .frame(width: 18, height: 1)
                        Text("\(item)00")
                            .frame(height: 1)
                    }
                    
                    VStack(alignment: .leading) {
                        
                        ForEach(1...9, id: \.self) { _ in
                            Spacer()
                            Rectangle()
                                .frame(width: 8, height: 1)
                        }
                        Spacer()
                        HStack {
                            Rectangle()
                                .frame(width: 18, height: 1)
                            Text("\(item - 1)50")
                                .frame(height: 1)
                                .font(.caption)
                        }
                        
                        ForEach(1...9, id: \.self) { _ in
                            Spacer()
                            Rectangle()
                                .frame(width: 8, height: 1)
                        }
                    }
                }
            }
        }
        .frame(width: 100, height: 700)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(hexCode: "282828"))
        )
        
        
    }
}

struct ThumbView: View {
    
    @Binding var value: Int
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 80, height: 30)
                .foregroundStyle(
                    LinearGradient(colors: [Color(hexCode: "EDEC66")!,Color(hexCode: "B4B300")!], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(colors: [Color(hexCode: "E1E000")!,Color(hexCode: "B4B300")!], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2
                        )
                )
            
            Text("\(value) kt")
                .foregroundColor(.black)
        }
    }
    
    
}


struct RangeView_Previews: PreviewProvider {
    static var previews: some View {
        RangeView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
