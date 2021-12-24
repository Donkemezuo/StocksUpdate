//
//  AuthenticationViewController.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/23/21.
//

import Foundation
import UIKit
import AuthenticationServices

class AuthenticationViewController: UIViewController {
    private let authManager = AuthenticationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        programmaticallyAddAppleSigninButtonToView()
    }
    
    private func programmaticallyAddAppleSigninButtonToView() {
        let appleSignButton = ASAuthorizationAppleIDButton()
        appleSignButton.addTarget(self, action: #selector(handleAppleSignin), for: .touchUpInside)
        view.addSubview(appleSignButton)
        appleSignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleSignButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleSignButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleSignButton.heightAnchor.constraint(equalToConstant: 50),
            appleSignButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }
    
    @objc private func handleAppleSignin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AuthenticationViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredentials as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredentials.user
            authManager.recordSuccessfulAuthentication(userIdentifier) {[weak self] in
                self?.showStocksListView()
            }
        default:
            return
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showAlert(title: " UnexpectedError encountered ", message: AppErrors.failedAuthenticationRequest(message: error.localizedDescription).errorDescription)
    }
}


extension AuthenticationViewController {
    func showStocksListView() {
        guard let stockListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StockListViewController") as? StockListViewController else { return }
        let stockListViewControllerNav = UINavigationController(rootViewController: stockListViewController)
        stockListViewControllerNav.modalPresentationStyle = .overCurrentContext
        present(stockListViewControllerNav, animated: true) {
            (UIApplication.shared.delegate as? SceneDelegate)?.window?.rootViewController = stockListViewControllerNav
        }
    }
}
