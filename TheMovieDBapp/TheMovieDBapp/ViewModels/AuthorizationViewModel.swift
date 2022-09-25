//
//  AuthorizationViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 25.09.2022.
//

import Foundation

class AuthorizationViewModel {
    var isLogin = Dynamic(false)
    let authNetworkManager = AuthNetworkManager()
    
    func signInDidTap( _ userName: String, _ password: String) {
        guard !userName.isEmpty,
              !password.isEmpty else {
            print("error")
//            TODO Alert
            return
        }
        authNetworkManager.logInWith(username: userName, password: password)
    }
}
