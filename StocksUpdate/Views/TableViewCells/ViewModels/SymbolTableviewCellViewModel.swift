//
//  SymbolTableviewCellViewModel.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/21/21.
//

import Foundation

struct SymbolTableviewCellViewModel {
    let open: String
    let close: String
    let high: String
    let low: String
    var symbolName: String? = nil 
    var openPrice: String {
        return "$\(open)"
    }
    
    var closePrice: String {
        return "$\(close)"
    }
    
    var highPrice: String {
        return "$\(high)"
    }
    
    var lowPrice: String {
        return "$\(low)"
    }
}
