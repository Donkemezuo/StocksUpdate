//
//  WebServiceTest.swift
//  StocksUpdateTests
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import XCTest
@testable import StocksUpdate

class WebServiceTest: XCTestCase {
    var sut: WebService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = WebService(endPoint: "", urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.stubResponseData = nil
    }
    
    func testWebService_WhenEmptyURLStringProvided_ShouldReturnError() {
        // Arrange
        let expectation = self.expectation(description: "An empty URL string expectation")
        
        // Act
        // Assert
        sut.fetchData(endPoint: "") { responseData, error in
            XCTAssertEqual(error, AppErrors.invalidURLString, "When an empty URL is provided, should return invalid URL String error but not returning error")
            XCTAssertNil(responseData, "When invalid url string is provided responseData() should return NILL but it is not returning nill")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testWebService_WhenValidURLProvided_ShouldReturnData() {
        // Arrange
        let expectation = self.expectation(description: "A valid URL String expectation")
        // Act
        // Assert
        sut.fetchData(endPoint: SymbolSearchEndpoint.monthly(searchedSymbol: nil).endPointsString) { responseData, error in
            XCTAssertNotNil(responseData, " When a valid URL is provided, responseData should return value but it is returning NILL")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testWebService_WhenURLRequestFails_ShouldReturnErrorMessageDescription() {
        // Arrange
        let expectation = self.expectation(description: "Failed Request expectation")
        let errorDescription = "A localized description of an error"
        MockURLProtocol.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        // Act
        sut.fetchData(endPoint: SymbolSearchEndpoint.daily(searchedSymbol: nil).endPointsString) { responseData, error in
            // Assert
            XCTAssertEqual(error, AppErrors.failedNetworkRequest(message: errorDescription))
            XCTAssertEqual(error?.localizedDescription, errorDescription)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    
}
