//
//  ContentView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 25.03.22.
//

import SwiftUI

struct NamedButton: Identifiable {
    let name: String
    var coordinates: [CGFloat]
    var id: String { name }
}


struct ButtonsView: View {
    
    @EnvironmentObject var appearanceVM: AppearanceViewModel
    
    @State var xPosition: CGFloat = 0
    @State var testOutput = "Test"
    
    @State var namedButtons: [NamedButton] = [
        NamedButton(name: "A", coordinates: [0,0]),
        NamedButton(name: "B", coordinates: [0,0]),
        NamedButton(name: "C", coordinates: [0,0]),
        NamedButton(name: "D", coordinates: [0,0])
    ]
    
    var body: some View {
        
        HStack(spacing: 150.0) {
            ForEach($namedButtons) { $namedButton in
                HStack {
                    Button(action: {
                        testOutput = namedButton.name }
                           , label: {
                        ZStack {
                            VStack {
                                Text("\(namedButton.name)")
                                    .font(.system(size: 72))
                                
                                // Coordinates inside buttosn
//                                if appearanceVM.settings.showTapLocation {
                                    Text("pressed at")
                                    // show coordinates rounded with 1 decimal place
                                    Text("x: \(String(format: "%.1f", namedButton.coordinates[0])) y: \(String(format: "%.1f",namedButton.coordinates[1]))")
//                                }
                                
                            }
                            
                            // Touch position indicator
                            if appearanceVM.showTapIndicator {
                                Rectangle()
                                    .frame(width: 5, height: 5)
                                    .foregroundColor(.green)
                                .offset(x: namedButton.coordinates[0], y: namedButton.coordinates[1])
                            }
                            
                        }
                        // Main color, size and border of buttons
                        .foregroundColor(Color.gray)
                        .frame(width: 150, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(Color.gray, lineWidth: 4)
                        )
                    })
                    .onTapWithLocation { location in
                        namedButton.coordinates[0] = location.x - 75
                        namedButton.coordinates[1] = location.y - 75
                        print("Button \(namedButton.name) pressed at location: \(location)")
                    }
                }
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       
        ButtonsView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
