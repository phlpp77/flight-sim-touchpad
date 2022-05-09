//
//  HeadingView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 09.05.22.
//

import SwiftUI

struct HeadingView: View {
    
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    
    @State var turnFactor = -1
    
    var body: some View {
        VStack {
            
            
            VStack {
                Text("Direction of turn")
                ZStack {
                    
                    // MARK: Indication Overlay
                    Capsule()
                        .frame(width: 100, height: 50)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color(hexCode: "828282")!, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(colors: [Color.white, Color(hexCode: "B9B9B9")!], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 4
                                ))
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(colors: [Color(hexCode: "B9B9B9")!, Color.white], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 2
                                ))
                        .offset(x: turnFactor != -1 ? (turnFactor == 0 ? -95 : 95) : 0)
                        .animation(.interactiveSpring(), value: turnFactor)
                    
                    // MARK: Buttons
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        
                        Button(action:  {
                            turnFactor = 0
                        }) {
                            Image(systemName: "arrow.turn.up.left")
                                .foregroundColor(turnFactor == 0 ? .black : .white)
                        }
                        
                        Image(systemName: "diamond.fill")
                            .font(.title3)
                            .foregroundColor(turnFactor == -1 ? .black : .white)
                        
                        Button(action:  {
                            turnFactor = 1
                        }) {
                            Image(systemName: "arrow.turn.up.right")
                                .foregroundColor(turnFactor == 1 ? .black : .white)
                        }
                    }
                    
                }
                .padding(6)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 300)
                .background(Color.black)
                .mask(Capsule())
            }
            
            RingSliderView(socketNetworkVM: socketNetworkVM, turnFactor: $turnFactor)
                .padding(.top, 30)
                .padding()
                .background(Color.black.opacity(0.8))
                .mask(RoundedRectangle(cornerRadius: 22))
        }
        .frame(width: 350)
    }
}

struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        HeadingView(socketNetworkVM: socketNetworkVM)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
