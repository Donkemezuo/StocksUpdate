//
//  WebServiceProtocol.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import Foundation

protocol WebServiceProtocol {
    func fetchData(endPoint: String, completionHandler: @escaping(Data?, AppErrors?) -> ())
}
