//
//  MainView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appearanceVM: AppearanceViewModel
    @EnvironmentObject var verticalSliderVM: VerticalSliderViewModel
    @EnvironmentObject var socketNetworkVM: SocketNetworkViewModel
    @EnvironmentObject var mqttNetworkVM: MQTTNetworkViewModel
    @EnvironmentObject var buttonsVM: ButtonsViewModel
    
    @State private var showPopover = false
    @State private var showSecondScreen = false
    @State private var showMasterWarn = false
    @State private var showInformationWindow = false
    
    var body: some View {
        ZStack {
            
            // MARK: - Background of entire app
            Rectangle()
                .fill(Color(hexCode: "141414")!)
                .ignoresSafeArea()
                .statusBar(hidden: true)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onEnded { action in
                            print("Global input at \(action.startLocation) at \(Date().localFlightSim())")
                            // MARK: Save Global input to log
                            let logData = LogData(attribute: "Global input", oldValue: 999999, value: 999999, relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: action.startLocation, startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
                            log.append(logData)
                            if mqttNetworkVM.connectionOpen {
                                mqttNetworkVM.sendToLog(logData)
                            }
                        }
                )
            
            // MARK: - Place all visual elements
            ZStack {
                
                // MARK: Main Screen
                HStack {
                    Spacer()
                    // Speed Slider
                    VerticalSliderView(step: appearanceVM.speedStepsInFive ? 10 : 1, minValue: 100, maxValue: 399, aircraftData: .speed, value: $verticalSliderVM.speed)
                    Spacer()
                    
                    // Center Area
                    VStack {
                        ATCMessagesView()
                        if appearanceVM.showTestValueWindow {
                            StateValuesTestView()
                                .hoverEffect()
                        }
                        Spacer()
                        ConfirmButtonView()
                        Spacer()
                        HeadingView()
                            .padding(.bottom, 30)
                    }
                    
                    Spacer()
                    // Altitude Slider
                    VerticalSliderView(step: 1000, minValue: 100, maxValue: 20000, aircraftData: .altitude, value: $verticalSliderVM.altitude)
                    Spacer()
                    // Verticalspeed Slider
                    VerticalSliderView(step: 100, minValue: -5000, maxValue: 5000, aircraftData: .verticalSpeed, value: $verticalSliderVM.verticalSpeed)
                    Spacer()
                }
                .opacity(appearanceVM.screen == .essential ? 1 : 0)
                
                // MARK: Secondary Screen
                HStack {
                    Spacer()
                    
                    // Side Area
                    VStack(spacing: 40.0) {
                        HStack(spacing: 20.0) {
                            MasterButtonsView(text: "warn", color: .red, active: $buttonsVM.masterWarn)
                            MasterButtonsView(text: "caution", color: .orange, active: $buttonsVM.masterCaution)
                        }
                        NavDisplayZoomView()
                    }
                    
                    Spacer()
                    // Speed brakes/Spoiler Slider
                    VerticalSliderView(topToBottom: true, minValue: 10, maxValue: 100, aircraftData: .spoiler, value: $verticalSliderVM.spoiler)
                    Spacer()
                    // Gear Slider
                    VerticalSliderView(topToBottom: true, minValue: 0, maxValue: 1, aircraftData: .gear, value: $verticalSliderVM.gear)
                    Spacer()
                    // Flaps Slider
                    VerticalSliderView(topToBottom: true, minValue: 0, maxValue: 4, aircraftData: .flaps, value: $verticalSliderVM.flaps)
                    Spacer()
                }
                .opacity(appearanceVM.screen == .additional ? 1 : 0)
            }
            .padding(.vertical, 15)
            
            
            // MARK: - Settings Button
            HStack {
                VStack {
                    Button(action: {
                        self.showPopover = true
                        print("Settings opened at \(Date().localFlightSim())")
                        // MARK: Save Settings opened to log
                        let logData = LogData(attribute: "Settings opened", oldValue: 999999, value: 999999, relativeDeviation: CGPoint(x: 999999, y: 999999), globalCoordinates: CGPoint(x: 999999, y: 999999), startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
                        log.append(logData)
                        if mqttNetworkVM.connectionOpen {
                            mqttNetworkVM.sendToLog(logData)
                        }
                    }) {
                        Image(systemName: "gear")
                        // MARK: Present settings View as a Sheet
                            .sheet(isPresented: $showPopover) {
                                SettingsView()
                            }
                    }
                    
                    Spacer()
                }
                .padding(.leading, 10)
                .font(.largeTitle)
                .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.top, 10)
            
            // MARK: Status View to show connection
            ZStack(alignment: .topLeading) {
                Color.clear
                if showInformationWindow {
                    LottieView(name: appearanceVM.mqttConnectionIsOpen ? "success" : "disconnect")
                        .frame(width: 150, height: 150)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        // MARK: Connect to server at startup
        .onAppear {
            SoundService.shared.serviceActivated = true
            mqttNetworkVM.openConnection()
        }
        .onChange(of: appearanceVM.mqttConnectionIsOpen) { isOpen in
            if isOpen! {
                SoundService.shared.connectSound()
                SoundService.shared.speakText("MQTT Connected")
            } else {
                SoundService.shared.disconnectSound()
                SoundService.shared.speakText("MQTT Disconnected")
            }
            showInformationWindow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showInformationWindow = false
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
