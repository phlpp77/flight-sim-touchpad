//
//  NavDisplayZoomView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 11.07.22.
//

import SwiftUI
import Introspect

struct NavDisplayZoomView: View {
    
    @EnvironmentObject var buttonsVM: ButtonsViewModel
    
    var body: some View {
        
        VStack {
            Text("Range-Selector for NAV")
                .font(.title3)
                .textCase(.uppercase)
                .foregroundColor(.gray)
            
            Picker(selection: $buttonsVM.toggleZoomFactor) {
                Text("10").tag(0)
                Text("20").tag(1)
                Text("40").tag(2)
            } label: {
                Text("Select ZOOM")
            }
            .introspectSegmentedControl { segmentedControl in
                segmentedControl.selectedSegmentTintColor = UIColor(Color(hexCode: "FFF000")!)
                segmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)
                segmentedControl.setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)
            }
            .pickerStyle(.segmented)
            .frame(width: 250)
            .scaledToFit()
            .scaleEffect(CGSize(width: 1.2, height: 1.2))
            
        }
        .padding(12)
        .padding(.bottom, 22)
        .frame(width: 350)
        .background(
            RoundedRectangle(cornerRadius: 22)
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
                    RoundedRectangle(cornerRadius: 22)
                        .strokeBorder(Color(hexCode: "979797")!, lineWidth: 0.5)
                    
                )
                .allowsHitTesting(false)
        )
        
    }
}

struct NavDisplayZoomView_Previews: PreviewProvider {
    static var previews: some View {
        NavDisplayZoomView()
    }
}
