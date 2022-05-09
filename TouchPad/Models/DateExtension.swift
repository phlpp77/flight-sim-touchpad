//
//  DateExtension.swift
//  TouchPad
//
//  Created by Philipp Hemkemeyer on 02.05.22.
//

import Foundation

extension Date {
    func localFlightSim() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "CEST")
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS ZZZZ"
        return dateFormatter.string(from: self)
    }
}
