//
//  NetworkError.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/18/21.
//

import Foundation

enum AppErrors: LocalizedError, Equatable {
    case invalidURLString
    case failedNetworkRequest(message: String)
    case jsonParsing
    case coreDataFetch
    
    var errorDescription: String? {
        switch self {
        case .failedNetworkRequest(message: let message):
            return message
        case .invalidURLString, .jsonParsing, .coreDataFetch:
            return ""
        }
    }
}
