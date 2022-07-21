//
//  UserDefaultsViewModel.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 21.07.22.
//

import Foundation
import Combine

class UserDefaultsViewModel: ObservableObject {
    
    let defaultService = UserDefaultsService()
    
    @Published var ips: [String: String]!
    
    init() {
        self.ips = defaultService.getValues()
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
    
    private func updateIPs() {
        self.ips = defaultService.getValues()
    }
}

