//
//  ThumbView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 16.06.22.
//

import SwiftUI

struct ThumbView: View {
    
    @Binding var value: Int
    var unit: String
    
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
            
            HStack(alignment: .bottom, spacing: 0.0) {
                Text("**\(value)**")
                Text("\(unit)")
                    .font(.caption)
            }
            .foregroundColor(.black)
        }
    }
}

struct ThumbView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(value: .constant(230), unit: "kt")
    }
}
