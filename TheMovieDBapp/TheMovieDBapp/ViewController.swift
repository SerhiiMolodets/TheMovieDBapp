//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import UIKit

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        networkManager.logInWith(username: "mr_molodets", password: "mukola123456")
        // Do any additional setup after loading the view.
    }

    @IBAction func signInDidTap(_ sender: UIButton) {
        guard let userName = userNameTextField.text,
              let password = passwordTextField.text,
              userName != "",
              password != "" else {
            print("error")
//            TODO Alert
            return
        }
        networkManager.logInWith(username: userName, password: password)
    }
    
}

