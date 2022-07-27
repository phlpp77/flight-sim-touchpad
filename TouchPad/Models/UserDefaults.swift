//
//  UserDefaults.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 21.07.22.
//

import Foundation
import Combine

class UserDefaultsService {
    
    // Access Shared Defaults Object
    private let userDefaults = UserDefaults.standard
    
    // Combine setup
    let didSetIPs = PassthroughSubject<Void, Never>()
    
    // Presets for standard IPs - only used during first setup of app
    private var IPs = [
        "Lab": "192.168.103.103",
        "Office": "192.168.103.105",
        "Localhost" : "localhost",
        "Homeoffice" : "192.168.178.76"
    ]
    
    // Only executed during first setup - values are saved on device
    init() {
        if getValues().isEmpty {
            userDefaults.set(IPs, forKey: "ips")
        }
    }
    
    /// Function to get values from device storage
    public func getValues() -> [String:String] {
        return userDefaults.object(forKey: "ips") as? [String:String] ?? [:]
    }
    
    /// Function to add a value to the device storage, the old array is needed because it overrides the whole entry
    public func addValue(to dic: [String:String], key: String, value: String) {
        var _dic = dic
        _dic[key] = value
        userDefaults.set(_dic, forKey: "ips")
        didSetIPs.send()
    }
    
}


