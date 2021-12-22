//
//  WebService.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/18/21.
//

import Foundation

class WebService: WebServiceProtocol {
    private var urlSession: URLSession
    private var endPoint: String
    init(endPoint: String, urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.endPoint = endPoint
    }
    /// - TAG: A function to fetch data from the endPoint
    func fetchData(endPoint: String, completionHandler: @escaping(Data?, AppErrors?) -> ()) {
        guard let url = URL(string: endPoint) else
        {
            completionHandler(nil, AppErrors.invalidURLString)
            return;
        }
        let request = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let responseError = error {
                completionHandler(nil, AppErrors.failedNetworkRequest(message: responseError.localizedDescription))
                return;
            } else if let data = data {
                completionHandler(data, nil)
                return;
            }
        }
        dataTask.resume()
    }
}
