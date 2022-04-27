//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var appearanceVM: AppearanceViewModel
    @ObservedObject var socketNetworkVM: SocketNetworkViewModel
    
    @State var receivedText = ""
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $appearanceVM.showTapLocation) {
                        Text("Show coordinates")
                    }
                    Toggle(isOn: $appearanceVM.showTapIndicator) {
                        Text("Show indicator")
                    }
                }
                
                Section(header: Text("Web Socket"), footer: Text("Without a connection to the Web Socket server it is not possible to run this app satisfactory")) {
                    
                    Text("Text: \(receivedText)")
                    
                    Button(action: {
                        socketNetworkVM.webSocketService.openWebSocket()
                    }) {
                        HStack {
                            Text("Server")
                            Spacer()
                            Text(socketNetworkVM.webSocketService.isConnectionOpen ? "Connected" : "Not connected")
                                .foregroundColor(.primary)
                        }
                    }
                
                    
                    Button(action: {
                        socketNetworkVM.webSocketService.sendString("[Client] Hello from iOS Client!")
                    }) {
                        Text("Send hello to server")
                    }
                    Button(action: {
                        receivedText = socketNetworkVM.webSocketService.declareOffsets()
                    }) {
                        Text("Declare Offsets")
                    }
                    Button(action: {
                        socketNetworkVM.webSocketService.speedTest()
                    }) {
                        Text("Set speed to 222")
                    }
                    
                    Button(action: {
                        let testPackageToSend = PackageToSend(name: "TestName", number: 13)
                        jsonEncoder.outputFormatting = .prettyPrinted
                        do {
                            let encodedTestPackage = try jsonEncoder.encode(testPackageToSend)
                            socketNetworkVM.webSocketService.sendData(encodedTestPackage)
                        } catch {
                            print(error.localizedDescription)
                        }
                        receivedText = socketNetworkVM.webSocketService.receiveMessage()
                    }) {
                        Text("Send data JSON")
                    }
                }
                
            }
            .navigationTitle(Text("Settings"))
            .navigationViewStyle(.stack)
        }
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
        let socketNetworkVM = SocketNetworkViewModel()
        SettingsView(appearanceVM: appearanceVM, socketNetworkVM: socketNetworkVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
