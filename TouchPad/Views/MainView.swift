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
            
            // MARK: Background of entire app
            Rectangle()
                .fill(Color(hexCode: "141414")!)
                .ignoresSafeArea()
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onEnded { action in
                            print("Global input at \(action.startLocation) at \(Date().localFlightSim())")
                            // MARK: Save to log
                            log.append(LogData(attribute: "Global input", oldValue: 0, value: 0, relativeDeviation: action.startLocation, time: Date().localFlightSim()))
                    }
                )
                
                
            HStack {
                Spacer()
                SpeedSliderView(socketNetworkVM: socketNetworkVM, minValue: 100, maxValue: 399, valueName: "speed")
                Spacer()
                VStack {
                    Spacer()
                    HeadingView(socketNetworkVM: socketNetworkVM)
                }
                Spacer()
                SliderView(socketNetworkVM: socketNetworkVM, minValue: 100, maxValue: 20000, valueName: "altitude")
                Spacer()
            }
                
            
            VStack {
                HStack {
                    Button(action: {
                            self.showPopover = true
                            print("Settings opened at \(Date().localFlightSim())")
                            // MARK: Save to log
                            log.append(LogData(attribute: "Settings opened", oldValue: 0, value: 0, relativeDeviation: CGPoint(x: 0, y: 0), time: Date().localFlightSim()))
                        }) {
                            Image(systemName: "gear")
                            .font(.largeTitle)
                            .padding(.leading, 15)
                            .foregroundColor(.gray)
                            .sheet(isPresented: $showPopover) {
                                SettingsView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM)
                            }
                    }
                    Spacer()
                }
                Spacer()
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
