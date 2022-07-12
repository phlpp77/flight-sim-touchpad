//
//  ConfirmButtonView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 12.07.22.
//

import SwiftUI

struct ConfirmButtonView: View {
    
    @EnvironmentObject var mqttVM: MQTTNetworkViewModel
    @State private var isPressed = false
    @State private var relativeCords: CGPoint = .zero
    private let buttonWidth: CGFloat = 200
    private let buttonHeight: CGFloat = 200
    
    var body: some View {
        ZStack {
            
            // Rounded Rectangle as the background
            Circle()
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0.3529411852359772, green: 0.35686275362968445, blue: 0.364705890417099, alpha: 1)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0.13333334028720856, green: 0.13725490868091583, blue: 0.14901961386203766, alpha: 1)), location: 0.4132560193538666),
                        .init(color: Color(#colorLiteral(red: 0.11865366250276566, green: 0.12366673350334167, blue: 0.1286797970533371, alpha: 1)), location: 0.4990449845790863),
                        .init(color: Color(#colorLiteral(red: 0.133970245718956, green: 0.13855677843093872, blue: 0.14772984385490417, alpha: 1)), location: 0.5881397724151611),
                        .init(color: Color(#colorLiteral(red: 0.3529411852, green: 0.3568627536, blue: 0.3647058904, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 1, y: 0),
                    endPoint: UnitPoint(x: 0, y: 0)))
                .overlay(
                    Circle()
                        .strokeBorder(Color(hexCode: "979797")!, lineWidth: 0.5)
                )
                .frame(width: buttonWidth, height: buttonHeight)
            
            Image(systemName: "checkmark.circle")
                .font(.system(size: 90))
                .foregroundColor(isPressed ? .green : .primary)
        }
        .coordinateSpace(name: "confirmButton")
        .opacity(isPressed ? 0.4 : 1)
        .scaleEffect(isPressed ? 1.2 : 1)
        .pressEvents {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation {
                isPressed = false
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("confirmButton"))
                .onChanged { actions in
                    let tappedCords = actions.startLocation
                    relativeCords = CGPoint(x: tappedCords.x - buttonWidth/2 , y: tappedCords.y - buttonHeight/2)
                    sendData()
                    SoundService.shared.successSound()
                })
        
    }
    
    private func sendData() {
        print("Confirm sent with relative deviation \(relativeCords) at \(Date().localFlightSim())")
        
        // MARK: Save to log
        // Create Log component
        let logData = LogData(attribute: "confirm", relativeDeviation: relativeCords, startTime: Date().localFlightSim(), endTime: Date().localFlightSim())
        // Add to local log on iPad
        log.append(logData)
        // Add to remote via MQTT
        if mqttVM.connectionOpen {
            mqttVM.sendToLog(logData)
        }
    }
}

struct ConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButtonView()
    }
}
