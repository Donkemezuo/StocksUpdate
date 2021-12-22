//
//  Date+Extensions.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import Foundation

extension Date {
    var formattedDateString_mmmddyyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
