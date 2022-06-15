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
    @State var showMasterWarn = false
    
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
                            log.append(LogData(attribute: "Global input", oldValue: 999999, value: 999999, relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: action.startLocation, startTime: Date().localFlightSim(), endTime: Date().localFlightSim()))
                        }
                )
            
            
            HStack {
                Spacer()
                VerticalSliderView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM, minValue: 100, maxValue: 399, valueName: "speed")
                Spacer()
                VStack {
                    ActiveButtonView(text: "WARN", color: .red, active: $showMasterWarn)
                    Spacer()
                    HeadingView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM)
                        .padding(.bottom, 30)
                }
                Spacer()
                VerticalSliderView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM, step: 100, minValue: 100, maxValue: 20000, valueName: "altitude")
                Spacer()
            }
            
            
            VStack {
                HStack {
                    Button(action: {
                        self.showPopover = true
                        print("Settings opened at \(Date().localFlightSim())")
                        // MARK: Save to log
                        log.append(LogData(attribute: "Settings opened", oldValue: 999999, value: 999999, relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: CGPoint(x: 999999, y: 999999), startTime: Date().localFlightSim(), endTime: Date().localFlightSim()))
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
            
            // Test rectangle
            //            Rectangle()
            //                .fill(.mint)
            //                .frame(width: 25, height: 25)
            //                .position(x: 580, y: 686)
            
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
