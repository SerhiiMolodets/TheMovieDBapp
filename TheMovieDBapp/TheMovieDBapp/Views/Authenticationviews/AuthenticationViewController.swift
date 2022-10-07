//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    lazy var authenticationViewModel = AuthenticationViewModel()
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestInButton: UIButton!

    let guestButtonTextAttributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 12),
          .foregroundColor: UIColor.white,
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 25, options: .allowAnimatedContent) {
            self.logoImageView.center.y = self.view.frame.height / 2
        }
    }
 
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signInButton.layerGradient()
    }
    func bindAuthentication() {
        if authenticationViewModel.isLogin {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let firstnavController = storyboard.instantiateViewController(withIdentifier: "firstNavControllerId")
                self.view.window?.rootViewController = firstnavController
                self.view.window?.makeKeyAndVisible()
            }
            
        }
    }
    
    @IBAction func signInDidTap(_ sender: UIButton) {
        authenticationViewModel.signInDidTap(userNameTextField.text ?? "", passwordTextField.text ?? "") {
            self.bindAuthentication()
        }
        
    }
    @IBAction func guestSignInDidTap(_ sender: UIButton) {
        authenticationViewModel.guestSignInDidTap {
            self.bindAuthentication()
        }

    }
// MARK: - Configure UI
    private func setupUI() {
        self.view.backgroundColor = UIColor(red: 0.023, green: 0.011, blue: 0.171, alpha: 1)
        // MARK: - Configure logo view
        logoImageView.image = UIImage(named: "logo.svg")

        // MARK: - Configure userNameTextField
        userNameTextField.layer.cornerRadius = 6
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor

        // MARK: - Configure passwordTextField
        passwordTextField.layer.cornerRadius = 6
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        // MARK: - Configure signInButton
        signInButton.layer.cornerRadius = 22
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        // MARK: - Configure gueastInButton
        let attributeString = NSMutableAttributedString(
           string: "Sign in as a Guest",
           attributes: guestButtonTextAttributes
        )
        guestInButton.setAttributedTitle(attributeString, for: .normal)
    }
    
}

extension AuthenticationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text,
            !text.isEmpty {
            signInButton.layerGradient()
            textField.addBorderGradient()
            textField.layer.borderWidth = 0

        }

        return true
    }
}
