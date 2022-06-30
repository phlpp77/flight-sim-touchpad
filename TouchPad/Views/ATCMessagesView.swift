//
//  ATCMessagesView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 30.06.22.
//

import SwiftUI

struct ATCMessagesView: View {
    
    @State var message: String = "Turn left HDG 300"
    
    private let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ATC")
                    .bold()
                    .font(.title2)
                Divider()
                    .overlay(Color(hexCode: "FFF000")!)
                Text("Current Messages")
                    .font(.title3)
            }
            .frame(height: 25)
            Divider()
                .overlay(Color(hexCode: "FFF000")!)
            Text("[\(Date(), formatter: dateFormatter())] \(message)")
                .textCase(.uppercase)
        }
        .frame(width: 450)
        .padding(10)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .foregroundColor(Color(hexCode: "FFF000")!)
        .shadow(radius: 12)
    }
}

struct ATCMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ATCMessagesView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
