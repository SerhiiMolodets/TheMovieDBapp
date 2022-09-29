//
//  AuthorizationViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 25.09.2022.
//

import Foundation

class AuthenticationViewModel {
    var isLogin = false

    func signInDidTap( _ userName: String, _ password: String, _ completionHandler: @escaping (() -> Void)) {
        guard !userName.isEmpty,
              !password.isEmpty else {
            print("error")
//            TODO Alert
            return
        }
        AuthNetworkManager.shared.makeMultiRequest(username: userName, password: password) { [weak self] success in
            guard let self = self else { return }
            self.isLogin = success
            completionHandler()
        }

    }
    
    func guestSignInDidTap(_ completionHandler: @escaping (() -> Void)) {
        AuthNetworkManager.shared.guestSession({ [weak self] guestSession in
            guard let self = self else { return }
            self.isLogin = guestSession.success
            completionHandler()
        })
    
    }
}
