//
//  ATCMessagesView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 30.06.22.
//

import SwiftUI

struct ATCMessagesView: View {
    
    @EnvironmentObject var atcMessagesVM: ATCMessagesViewModel
    
    private let animationTime: Double = 20
    private let additionalMessageShowTime: Double = 5
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var showDivider = false
    
    private let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(identifier: "UTC")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ATC")
                    .bold()
                    .font(.title2)
                Divider()
                    .overlay(Color(hexCode: "FFF000")!)
                Text("Current Messages")
                    .font(.title3)
            }
            .frame(height: 25)
            Divider()
                .overlay(Color(hexCode: "FFF000")!)
            Text("[\(dateFormatter().string(from: Date())) UTC] \(atcMessagesVM.message != "" ? atcMessagesVM.message : "No new message")")
                .textCase(.uppercase)
            Divider()
                .overlay(Color(hexCode: "FFF000")!)
                .opacity(showDivider ? 1 : 0)
            progressBar
        }
        .frame(width: 450)
        .padding(10)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .foregroundColor(Color(hexCode: "FFF000")!)
        .shadow(radius: 12)
        .onChange(of: atcMessagesVM.message) { _ in
            if atcMessagesVM.message != "" {
                animateProgressBar()
            }
        }
    }
    
    private var progressBar: some View {
        HStack {
            Spacer()
            Capsule()
                .frame(width: width, height: height)
            Spacer()
        }
    }
    
    private func animateProgressBar() {
        // animate divider and full height needed
        withAnimation(.easeInOut) {
            height = 20
            showDivider = true
        }
        // extend the progress bar to the maximum
        width = 436
        // animate down to 0 with duration
        withAnimation(.linear(duration: animationTime)) {
            width = 0
        }
        // disable divider and close height after other animation finished
        withAnimation(.easeInOut.delay(animationTime)) {
            height = 0
            showDivider = false
        }
        // erase the message after additional time
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime + additionalMessageShowTime) {
            atcMessagesVM.message = ""
        }
    }
}

struct ATCMessagesView_Previews: PreviewProvider {
    
    static let envObj = ATCMessagesViewModel(state: TouchPadModel())
    
    static var previews: some View {
        ATCMessagesView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(envObj)
    }
}
