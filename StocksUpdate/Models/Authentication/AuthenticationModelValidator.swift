//
//  AuthenticationModelValidator.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/18/21.
//

import Foundation
class AuthenticationModelValidator {
    func isFullNameValid(fullname: String) -> Bool {
        var resultValue = true
        if fullname.count < AuthenticationConstants.fullnameMinCharacterCount || fullname.count > AuthenticationConstants.fullnameMaxChartacterCount {
            resultValue = false
        }
        return resultValue
    }
    
    func isEmailValid(email: String) -> Bool {
        var resultValue = true
        if !email.contains(AuthenticationConstants.atSign) || !email.contains(AuthenticationConstants.dot) {
            resultValue = false
        }
        return resultValue
    }
}
