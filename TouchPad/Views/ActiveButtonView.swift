//
//  ActiveButtonView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 13.06.22.
//

import SwiftUI

struct ActiveButtonView: View {
    
    var text: String
    var color: Color
    @Binding var active: Bool
    
    @State var animate = true
    
    var body: some View {
        
            VStack {
                Text("MASTER")
                    .foregroundColor(color.opacity(animate ? 1 : 0))
                Text(text)
                    .foregroundColor(color.opacity(animate ? 1 : 0))
            }
    //        .foregroundColor(animate ? color : .black)
            
            .animation(Animation.easeInOut(duration: 1.8), value: animate)
            .frame(width: 120, height: 120)
            .font(Font.system(.title2).bold())
            .background(.black)
            .mask(RoundedRectangle(cornerRadius: 22))
            
            
                
        
        }
        
        
        
    }


struct ActiveButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        ActiveButtonView(text: "WARN", color: .red, active: .constant(true))
    }
}
