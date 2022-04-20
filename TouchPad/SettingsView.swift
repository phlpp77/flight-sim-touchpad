//
//  SettingsView.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 01.04.22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var appearanceVM: AppearanceViewModel
    
    @State var showLocation: Bool = false
    @State var showTapIndicator: Bool = false
    
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
                
                Section(header: Text("Web Socket")) {
                    Button(action: {
                        appearanceVM.webSocketService.openWebSocket()
                    }) {
                        HStack {
                            Text("Server")
                            Spacer()
                            if appearanceVM.isConnectionOpen() {
                                Text("Connected")
                                    .foregroundColor(.primary)
                            } else {
                                Text("Not connected")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    Button(action: {
                        appearanceVM.webSocketService.sendString("[Client] Hello from iOS Client!")
                    }) {
                        Text("Send hello to server")
                    }
                    Button(action: {
                        let testPackageToSend = PackageToSend(name: "TestName", number: 13)
                        jsonEncoder.outputFormatting = .prettyPrinted
                        do {
                            let encodedTestPackage = try jsonEncoder.encode(testPackageToSend)
                            appearanceVM.webSocketService.sendData(encodedTestPackage)
                        } catch {
                            print(error.localizedDescription)
                        }
                        appearanceVM.webSocketService.receiveMessage()
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
        SettingsView(appearanceVM: appearanceVM)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
