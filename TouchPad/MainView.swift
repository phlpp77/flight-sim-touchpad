//
//  MainView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct MainView: View {
    
    let appearanceVM = AppearanceViewModel()
    let socketNetworkVM = SocketNetworkViewModel()
    
    @State var showPopover = false
    
    var body: some View {
        ZStack {
            ButtonsView(appearanceVM: appearanceVM)
            SliderView(socketNetworkVM: socketNetworkVM)
            
            GeometryReader { geo in
                Button(action: {self.showPopover.toggle()}) {
                    Image(systemName: "gear")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .offset(x: 30, y: 10)
                    .sheet(isPresented: $showPopover) {
                        SettingsView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM)
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
