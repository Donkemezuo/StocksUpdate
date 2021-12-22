//
//  StockDetailsViewModel.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/21/21.
//

import Foundation
import CoreData

struct StockDetailsViewModel {
    let open: String
    let close: String
    let high: String
    let low: String
    let date: String
    let symbolName: String
    var openingPrice: String {
        return "$\(open)"
    }
    var closingPrice: String {
        return "$\(close)"
    }
    var lowPrice: String {
        return "$\(low)"
    }
    var highPrice: String {
        return "$\(high)"
    }
    var isFavorited: Bool = false
    var coreDataVersion: CoreDataModel {
        return CoreDataModel(symbolName: symbolName, low: low, id: date, open: open, close: close, high: high, favoritedDate: Date().description)
    }
}

struct CoreDataModel {
    let symbolName: String
    let low: String
    let id: String
    let open: String
    let close: String
    let high: String
    let favoritedDate: String
}
