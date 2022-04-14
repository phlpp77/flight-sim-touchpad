//
//  MainView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct MainView: View {
    
    let appearanceVM = AppearanceViewModel()
    
    @State var showPopover = false
    
    var body: some View {
        ZStack {
            ButtonsView(appearanceVM: appearanceVM)
            
            GeometryReader { geo in
                Button(action: {self.showPopover.toggle()}) {
                    Image(systemName: "gear")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .offset(x: 30, y: 10)
                    .popover(isPresented: $showPopover) {
                        SettingsView(appearanceVM: appearanceVM)
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
