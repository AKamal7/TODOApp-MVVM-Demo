//
//  SignUpView.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/26/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignUpView: UIView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

        func setup() {
            setupTextField(emailTextField, placeHolder: "email", isSecure: false)
            setupTextField(passwordTextField, placeHolder: "password", isSecure: true)
            setupSignUpButton()
        }
        
        func setupTextField(_ textField: UITextField, placeHolder: String, isSecure: Bool) {
            textField.backgroundColor = .blue
            textField.placeholder = placeHolder
            textField.font = UIFont(name: emailTextField.font!.fontName, size: 20)
            textField.isSecureTextEntry = isSecure
        }
        
        func setupSignUpButton() {
            signUpButton.backgroundColor = .blue
            signUpButton.setTitle("Sign Up", for: .normal)
            signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        }
        
        
}
