//
//  WeeklySymbol.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/20/21.
//

import Foundation

struct WeeklySymbol: Codable {
    let metaData: MetaDataWeekly
    let weeklyTimeSeries: [String: WeeklyTimeSeries]
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case weeklyTimeSeries = "Weekly Time Series"
    }
}

struct MetaDataWeekly: Codable {
    let symbol: String
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct WeeklyTimeSeries: Codable {
    let openingPrice: String
    let high: String
    let low: String
    let close: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case openingPrice = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
