//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    lazy var authenticationViewModel = AuthenticationViewModel()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func bindAuthentication() {
        if authenticationViewModel.isLogin {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let firstnavController = storyboard.instantiateViewController(withIdentifier: "firstNavControllerId")
            view.window?.rootViewController = firstnavController
            view.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func signInDidTap(_ sender: UIButton) {
        authenticationViewModel.signInDidTap(userNameTextField.text ?? "", passwordTextField.text ?? "")
        DispatchQueue.main.async {
            self.bindAuthentication()
        }
      
    }
}
