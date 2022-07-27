//
//  UserDefaultsViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 21.07.22.
//

import Foundation
import Combine

class UserDefaultsViewModel: ObservableObject {
    
    // Create object of the userDefaultsService to interact with the state
    let defaultService = UserDefaultsService()
    
    // Var which is used by the View - informs the view about updates
    @Published var ips: [String: String]!
    
    init() {
        self.updateIPs()
        
        // setup combine
        self.setupSubscribers()
    }
    
    // MARK: Combine setup
    private var subscriptions = Set<AnyCancellable>()
    private func setupSubscribers() {
        defaultService.didSetIPs
            .sink {
                self.updateIPs()
            }
            .store(in: &subscriptions)
    }
    
    /// Function to update the IPs from the state - in this case saved on device
    private func updateIPs() {
        self.ips = defaultService.getValues()
    }
}

