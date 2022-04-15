//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var appearanceVM: AppearanceViewModel
    
    var webSocketService = SocketNetworkService()
    
    @State var showLocation: Bool = false
    @State var showTapIndicator: Bool = false
    
    var body: some View {
        
        VStack {
            Text("Settings")
                .font(.largeTitle)
            List {
//                Toggle(isOn: $showLocation) {
//                    Text("Show location in Button")
//                }
                Button(action: {
                    appearanceVM.toggleTapLocation()
                }) {
                    Text("Toggle Tap Location")
                }
                Toggle(isOn: $showTapIndicator) {
                    Text("Show Tap-indicator")
                }
                Button(action: {
                    webSocketService.openWebSocket()
                }) {
                    Text("Activate WebSocket connection")
                }
                Button(action: {
                    webSocketService.sendString("[Client] Hello from iOS Client!")
                }) {
                    Text("Send hello to server")
                }
                Button(action: {
//                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let testPackageToSend = PackageToSend(name: "TestName", number: 13)
                    jsonEncoder.outputFormatting = .prettyPrinted
                    do {
                    let encodedTestPackage = try jsonEncoder.encode(testPackageToSend)
                    webSocketService.sendData(encodedTestPackage)
                    } catch {
                        print(error.localizedDescription)
                    }
                    webSocketService.receiveMessage()
                }) {
                    Text("Send data JSON")
                }
            }
        }
        .frame(width: 400, height: 400)
        .accessibilityLabel("Settings")
    }
}

// test stuff
let testPackage = """
{
  "name": "Josh",
  "number": 30,
  "details": {
    "content": "much content",
    "tag": "tagsss"
  }
}
"""

let testPackageData = Data(testPackage.utf8)
let jsonDecoder = JSONDecoder()
let jsonEncoder = JSONEncoder()


struct PackageToSend: Codable {
    var name: String
    var number: Int
    
    struct Details: Codable {
        var content: String
        var tag: String
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let appearanceVM = AppearanceViewModel()
        SettingsView(appearanceVM: appearanceVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
