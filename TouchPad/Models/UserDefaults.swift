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
    
    // Create and Write Dictionary
    private var IPs = [
        "Lab": "192.168.103.103",
        "Office": "192.168.103.105",
        "Localhost" : "localhost",
        "Homeoffice" : "192.168.178.76"
    ]
    
    init() {
        userDefaults.set(IPs, forKey: "ips")
    }
    
    public func getValues() -> [String:String] {
        return userDefaults.object(forKey: "ips") as? [String:String] ?? [:]
    }
    
    public func addValue(to dic: [String:String], key: String, value: String) {
        var _dic = dic
        _dic[key] = value
        userDefaults.set(_dic, forKey: "ips")
        print("key updated")
        didSetIPs.send()
    }
    
}


