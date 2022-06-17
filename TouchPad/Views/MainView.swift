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
    let mqttNetworkVM = MQTTNetworkViewModel()
    
    @State var showPopover = false
    @State var showSecondScreen = false
    @State var showMasterWarn = false
    
    var body: some View {
        ZStack {
            
            // MARK: Background of entire app
            Rectangle()
                .fill(Color(hexCode: "141414")!)
                .ignoresSafeArea()
                .statusBar(hidden: true)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onEnded { action in
                            print("Global input at \(action.startLocation) at \(Date().localFlightSim())")
                            // MARK: Save to log
                            let logData = LogData(attribute: "Global input", oldValue: 999999, value: 999999, relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: action.startLocation, startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
                            log.append(logData)
                            if mqttNetworkVM.connectionOpen {
                                mqttNetworkVM.sendToLog(logData)
                            }
                        }
                )
            
                ZStack {
                    HStack {
                        Spacer()
                        VerticalSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, appearanceVM: appearanceVM, minValue: 100, maxValue: 399, aircraftData: .speed)
                        Spacer()
                        VStack {
        //                    ActiveButtonView(text: "WARN", color: .red, active: $showMasterWarn)
                            Spacer()
                            HeadingView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, appearanceVM: appearanceVM)
                                .padding(.bottom, 30)
                        }
                        Spacer()
                        VerticalSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, appearanceVM: appearanceVM, step: 100, minValue: 100, maxValue: 20000, aircraftData: .altitude)
                        Spacer()
                    }
                    .opacity(showSecondScreen ? 0 : 1)
                    
                
                    HStack {
                        Spacer()
                        VerticalSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, appearanceVM: appearanceVM, topToBottom: true, minValue: 0, maxValue: 4, aircraftData: .flaps)
                        Spacer()
                        VerticalSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, appearanceVM: appearanceVM, topToBottom: true, minValue: 0, maxValue: 1, aircraftData: .gear)
                        Spacer()
                        VerticalSliderView(socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM, appearanceVM: appearanceVM, topToBottom: true, minValue: 0, maxValue: 100, aircraftData: .spoiler)
                        Spacer()
                    }
                    .opacity(showSecondScreen ? 1 : 0)
                   
                }
                .padding(.vertical, 15)
            
            
            
            HStack {
                VStack(spacing: 20) {
                    
                    // MARK: Settings Button
                    Button(action: {
                        self.showPopover = true
                        print("Settings opened at \(Date().localFlightSim())")
                        // MARK: Save to log
                        let logData = LogData(attribute: "Settings opened", oldValue: 999999, value: 999999, relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: CGPoint(x: 999999, y: 999999), startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
                        log.append(logData)
                        if mqttNetworkVM.connectionOpen {
                            mqttNetworkVM.sendToLog(logData)
                        }
                    }) {
                        Image(systemName: "gear")
                            .sheet(isPresented: $showPopover) {
                                SettingsView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM, mqttNetworkVM: mqttNetworkVM)
                            }
                    }
                    
                    // MARK: Screen Switch Button
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showSecondScreen.toggle()
                        }
                        
                        // MARK: Save to log
                        let screenNumber = showSecondScreen ? 0 : 1
                        let oldScreenNumber = showSecondScreen ? 1 : 0
                        print("Screen switched from Screen \(screenNumber) to \(oldScreenNumber) at \(Date().localFlightSim())")
                        let logData = LogData(attribute: "Screen switched", oldValue: Double(oldScreenNumber), value: Double(screenNumber), relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: CGPoint(x: 999999, y: 999999), startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
                        log.append(logData)
                        if mqttNetworkVM.connectionOpen {
                            mqttNetworkVM.sendToLog(logData)
                        }
                    } label: {
                        Image(systemName: "rectangle.on.rectangle")
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .font(.largeTitle)
                .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.top, 10)
            
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
