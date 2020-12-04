//
//  SignInView.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/26/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInView: UIView {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    func setup() {
        setupTextField(emailTextField, placeHolder: "email", isSecure: false)
        setupTextField(passwordTextField, placeHolder: "password", isSecure: true)
        setupSignInButton()
        setupCreateAccountButton(createAccountButton, title: "create account")
    }
    
    func setupTextField(_ textField: UITextField, placeHolder: String, isSecure: Bool) {
        textField.backgroundColor = .systemBackground
        textField.placeholder = placeHolder
        textField.font = UIFont(name: emailTextField.font!.fontName, size: 20)
        textField.isSecureTextEntry = isSecure
    }
    
    func setupSignInButton() {
        signInButton.backgroundColor = .link
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
    }
    
    func setupCreateAccountButton(_ button: UIButton, title: String) {
        button.layer.borderWidth = 0.0
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.underlineStyle: 1.0])
        button.setAttributedTitle(attributedString, for: .normal)
    }
    
    
    
}
