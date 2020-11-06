//
//  SignUpVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text, isvalidName(name: name),
            let email = emailTextField.text, isValidEmail(email: email),
            let password = passwordTextField.text, isValidPassword(password: password),
            let ageString = ageTextField.text, isValidAge(age: ageString),
            let age = Int(ageString) else { return }
        let user = User(email: email, password: password, age: age , name: name)
        register(with: user)
        
    }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        return signUpVC
    }
}
    


    
    extension SignUpVC {
        
        // MARK:- Private Methods
        private func register(with user: User) {
            self.view.showLoader()
            APIManager.register(with: user) { (error, signUpResponse)  in
                if let error = error {
                    self.showAlert(title: "Attention", message: "This email is already in use", actionTitle: "OK")
                    print(error.localizedDescription)
                } else if let signUpResponse = signUpResponse {
                    UserDefaultsManager.shared().token = signUpResponse.token
                    self.goToMainVC()
                    print(signUpResponse.user.email)
                }
                self.view.hideLoader()
            }
        }
        private func isValidEmail(email: String?) -> Bool {
            let regEx =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
            if let email = email, email.isEmpty || !pred.evaluate(with: email)  {
                self.showAlert(title: "Email is Invalid", message: "Email should be ex: alex@gmail.com", actionTitle: "OK")
                return false
            }
            return true
        }
        
        private func isValidPassword(password: String?) -> Bool {
            guard let password = password, !password.isEmpty, password.count >= 8 else {
                print("password must be at least 8 characters")
                showAlert(title: "Password is wrong", message: "password must be at least 8 characters", actionTitle: "OK")
                return false
            }
            return true
        }
        private func isvalidName(name: String?) -> Bool {
            let regEx = "^[a-zA-Z- ]*$"
            let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
            if let name = name?.trimmed, name.isEmpty || !pred.evaluate(with: name)  {
                self.showAlert(title: "Name is Invalid", message: "Name shouldn't contain numbers or special characters", actionTitle: "OK")
                return false
            }
            return true
        }
        private func isValidAge(age: String?) -> Bool {
            if let age = age , age.isEmpty {
                showAlert(title: "Invalid Age", message: "You must be 18 at least ", actionTitle: "OK")
                return false
            }
            return true
        }
        
        private func goToMainVC() {
            let toDoListVC =  TodoListVC.create()
            let toDoListNav = UINavigationController(rootViewController: toDoListVC)
            AppDelegate.shared().window?.rootViewController = toDoListNav
        }
    }
    
    
    

