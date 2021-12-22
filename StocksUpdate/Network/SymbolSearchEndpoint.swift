//
//  NetworkServiceConstants.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/20/21.
//

import Foundation

enum SymbolSearchEndpoint {
    case daily(searchedSymbol: String?)
    case weekly(searchedSymbol: String?)
    case monthly(searchedSymbol: String?)
    
    private var apiKey: String { return "A3W1M6YS5SX6XNWW" }
    private var baseURL: String { return "https://www.alphavantage.co/query?function" }
    
    var endPointsString: String {
        switch self {
        case .daily(searchedSymbol: let symbol):
            return "\(baseURL)=TIME_SERIES_DAILY&symbol=\(symbol ?? "IBM")&apikey=\(apiKey)"
        case .weekly(searchedSymbol: let symbol):
            //https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=IBM&apikey=demo
            return "\(baseURL)=TIME_SERIES_WEEKLY&symbol=\(symbol ?? "IBM")&apikey=\(apiKey)"
        case .monthly(searchedSymbol: let symbol):
            return "\(baseURL)=TIME_SERIES_MONTHLY&symbol=\(symbol ?? "IBM")&apikey=\(apiKey)"
        }
    }
}
