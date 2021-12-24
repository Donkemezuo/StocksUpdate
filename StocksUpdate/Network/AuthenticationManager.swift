//
//  AuthenticationManager.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/23/21.
//

import Foundation

class AuthenticationManager {
    private let userDefault = UserDefaults.standard
    func isUserAuthenticated() -> Bool {
        guard userDefault.string(forKey: AuthenticationConstants.userDefaultKey) != nil else {
            return false
        }
        return true
    }
    
    func recordSuccessfulAuthentication(_ userID: String, completed: () -> ()) {
        if userDefault.string(forKey: AuthenticationConstants.userDefaultKey) == nil {
            userDefault.setValue(userID, forKey: AuthenticationConstants.userDefaultKey)
            completed()
        }
    }
    
}
