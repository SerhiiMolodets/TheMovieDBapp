//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import UIKit

class AuthorizationViewController: UIViewController {
    var authorizationViewModel = AuthorizationViewModel()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func bindAuthorizationModel() {
        authorizationViewModel.isLogin.bind { isLogin in
            //            TODO present new vc
        }
    }
    
    @IBAction func signInDidTap(_ sender: UIButton) {
        authorizationViewModel.signInDidTap(userNameTextField.text ?? "", passwordTextField.text ?? "")
        bindAuthorizationModel()
    }
    
}
