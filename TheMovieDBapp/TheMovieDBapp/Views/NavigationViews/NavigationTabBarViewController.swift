//
//  NavigationTabBarViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 15.10.2022.
//

import UIKit

class NavigationTabBarViewController: UITabBarController {

    @IBAction func signOutButtonDidTap(_ sender: Any) {
        AuthNetworkManager.shared.logOut { responce in
            if responce.success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let authController = storyboard.instantiateViewController(withIdentifier: "AuthControllerID")
                    self.view.window?.rootViewController = authController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
}
