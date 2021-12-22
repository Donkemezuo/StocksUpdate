//
//  String+Extensions.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/21/21.
//

import Foundation

extension String {
    var formattedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
}
