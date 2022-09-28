//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    lazy var authenticationViewModel = AuthenticationViewModel()
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red: 0.012, green: 0.145, blue: 0.255, alpha: 1).cgColor
        // MARK: - Comfigure logo label
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "VectorLogo.png")
        logoLabel.attributedText = NSAttributedString(attachment: attachment)

        // MARK: - Comfigure userNameTextField
        userNameTextField.addBottomBorder()
        userNameTextField.attributedPlaceholder = NSAttributedString(
            string: "User name*",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        // MARK: - Comfigure passwordTextField
        passwordTextField.addBottomBorder()
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password*",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        // MARK: - Comfigure signInButton
        signInButton.layer.cornerRadius = 18
        signInButton.layerGradient()
        
        // MARK: - Comfigure guestInButton

        
        
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
    
}

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = .none
        self.layer.masksToBounds = true
        layer.addSublayer(bottomLine)
    }
}

extension UIView {
    func layerGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors =
        [UIColor(red: 0.392, green: 0.824, blue: 0.675, alpha: 1).cgColor,
          UIColor(red: 0.31, green: 0.702, blue: 0.875, alpha: 1).cgColor]
        self.layer.masksToBounds = true
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
