//
//  AuthenticationModelValidatorTest.swift
//  StocksUpdateTests
//
//  Created by Raymond Donkemezuo on 12/18/21.
//

import XCTest
@testable import StocksUpdate

class AuthenticationModelValidatorTest: XCTestCase {
    var sut: AuthenticationModelValidator!
    
    override func setUp() {
        sut = AuthenticationModelValidator()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAuthenticationModelValidator_WhenFullnameProvided_ShouldReturnTrue() {
        // Arrange
        // Act
        let isFullnameValid = sut.isFullNameValid(fullname: "Raymond Donkemezuo")
        // Assert
        XCTAssertTrue(isFullnameValid, "The isFullnameValid() should have returned TRUE for a valid full name but returned FALSE")
    }
    
    func testAuthenticationModelValidator_WhenFullnameProvidedTooShort_ShouldReturnFalse() {
        // Arrange
        // Act
        let isFullnameValid = sut.isFullNameValid(fullname: "R")
        // Assert
        XCTAssertFalse(isFullnameValid, "The isFullnameValid() should have returned FALSE for a full name that is shorter than \(AuthenticationConstants.fullnameMinCharacterCount) characters but it has returned TRUE")
    }
    
    func testAuthenticationModelValidator_WhenFullnameProvidedTooLong_ShouldReturnFalse() {
        // Arrange
        // Act
        let isFullnameValid = sut.isFullNameValid(fullname: "Raymond")
        // Assert
        XCTAssertFalse(isFullnameValid, "The isFullnameValid() should have returned FALSE for a full name that is longer than \(AuthenticationConstants.fullnameMaxChartacterCount) characters but it has returned TRUE")
    }
    
    func testAuthenticationModelValidator_WhenEmailProvided_ShouldReturnTrue() {
        // Arrange
        // Act
        let isEmailValid = sut.isEmailValid(email: "test@test.com")
        // Assert
        XCTAssertTrue(isEmailValid, "The isEmailValid() should have returned TRUE for a valid email but returned FALSE")
    }
    
    func testAuthenticationModelValidator_WhenInvalidEmailProvided_ShouldReturnFalse() {
        // Arrange
        // Act
        let isEmailValid = sut.isEmailValid(email: "testtest.com")
        // Assert
        XCTAssertFalse(isEmailValid, "The isEmailValid() should have returned FALSE for an invalid email but returned TRUE")
    }
    
}
