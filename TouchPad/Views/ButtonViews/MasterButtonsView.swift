//
//  MasterButtonsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.06.22.
//

import SwiftUI

struct MasterButtonsView: View {
    
    @EnvironmentObject var buttonsVM: ButtonsViewModel
    
    var text: String
    var color: Color
    @Binding var active: Bool
    
    var body: some View {
        
        // Master warn button is blinking, the caution button is not
        VStack {
            if text == "warn" {
                Text("MASTER")
                    .blinking(duration: 0.4)
                Text(text)
                    .blinking(duration: 0.4)
            } else {
                Text("Master")
                Text(text)
            }
            
        }
        .foregroundColor(color.opacity(active ? 1 : 0))
        .textCase(.uppercase)
        .animation(Animation.easeInOut(duration: 1.8), value: active)
        .frame(width: 120, height: 120)
        .font(Font.system(.title2).bold())
        .background(.black)
        .mask(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .gray.opacity(0.6), radius: 6, x: 3, y: 2)
        .onTapWithLocation { location in
            if text == "warn" {
                buttonsVM.deactivateMasterWarn()
            } else if text == "caution" {
                buttonsVM.deactivateMasterCaution()
            }
        }
    }
}


struct ActiveButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        MasterButtonsView(text: "WARN", color: .red, active: .constant(true))
    }
}
