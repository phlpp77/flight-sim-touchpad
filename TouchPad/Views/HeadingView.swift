//
//  HeadingView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 09.05.22.
//

import SwiftUI

struct HeadingView: View {
    
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    @ObservedObject var appearanceVM: AppearanceViewModel
    
    @State var turnFactor = 1
    
    var body: some View {
        VStack {
            
            VStack {
                Text("Direction of turn")
                    .padding()
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
                        .offset(x: turnFactor == 0 ? -95 : 95)
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
            
            
            ZStack {
                
                Image("Circle-Background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                RingSliderView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM, turnFactor: $turnFactor)
                    .padding(53)
                
            }
            .padding(.top, 30)
            .padding()
            
            
        }
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

struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        let socketNetworkVM = SocketNetworkViewModel()
        let appearanceVM = AppearanceViewModel()
        HeadingView(socketNetworkVM: socketNetworkVM, appearanceVM: appearanceVM)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
