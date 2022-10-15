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
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAnimation()
    }
    // MARK: - Update gradient with rotating device
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signInButton.layerGradient()
    }
    // MARK: - Check authentication result and make root VC
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
    // MARK: - Sign In button action
    @IBAction func signInDidTap(_ sender: UIButton) {
        authenticationViewModel.signInDidTap(userNameTextField.text ?? "", passwordTextField.text ?? "") {
            self.bindAuthentication()
        }
        
    }
    // MARK: - Guest In button action
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
        let guestButtonTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: "Sign in as a Guest",
            attributes: guestButtonTextAttributes
        )
        guestInButton.setAttributedTitle(attributeString, for: .normal)
    }
    
}
// MARK: - Check textfields are empties, update UI
extension AuthenticationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let usernameText = userNameTextField.text,
           let passwordText = passwordTextField.text,
           !usernameText.isEmpty,
           !passwordText.isEmpty {
            signInButton.layerGradient()
            userNameTextField.addBorderGradient()
            passwordTextField.addBorderGradient()
            userNameTextField.layer.borderWidth = 0
            passwordTextField.layer.borderWidth = 0
        }
        
        return true
    }
    // MARK: - Setup logo animation
    private func startAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 25, options: .allowAnimatedContent) {
            self.logoImageView.center.y = self.view.frame.height / 2
        }
    }
}
