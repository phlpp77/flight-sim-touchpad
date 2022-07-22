//
//  TimeControl.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 19.07.22.
//

import Foundation

public class Time_Control: Thread {
    
    var wait_time: Double //In seconds
    public var can_send: Bool = true
    
    init(_ wait_time: Double) {
        self.wait_time = wait_time
    }
    
    public override func start() {
        super.start()
        
        self.can_send = false
        DispatchQueue.main.asyncAfter(deadline: .now() + self.wait_time) {
            self.can_send = true
        }
    }
}
