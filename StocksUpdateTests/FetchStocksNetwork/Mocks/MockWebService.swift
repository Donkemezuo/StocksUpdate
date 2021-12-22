//
//  MockWebService.swift
//  StocksUpdateTests
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import Foundation
@testable import StocksUpdate

class MockWebService: WebServiceProtocol {
    var isFetchDataMethodCalled = false
    var shouldReturnError = false
    func fetchData(endPoint: String, completionHandler: @escaping (Data?, AppErrors?) -> ()) {
        isFetchDataMethodCalled = true
        if shouldReturnError {
            completionHandler(nil, AppErrors.failedNetworkRequest(message: "Network request not successful"))
        } else {
            completionHandler(Data(), nil)
        }
    }
}
