//
//  MockURLProtocol.swift
//  StocksUpdateTests
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        
        // We will return the predefined hard coded data instead of making an actual network call
        if let signupError = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: signupError)
        } else if let stubResponseData = MockURLProtocol.stubResponseData {
            self.client?.urlProtocol(self, didLoad: stubResponseData)
        }
        // This will call the completion handler to say the network call is over
        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}
