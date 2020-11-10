//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, isValidEmail(email: email),
            let password = passwordTextField.text, isValidPassword(password: password) else {return}
        login(email: email, password: password)
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
    
}

extension SignInVC {
    // MARK:- API
    private func login(email: String, password: String ) {
        self.view.showLoader()
        APIManager.login(with: email, password: password) { (error, loginData) in
            if let error = error {
                self.showAlert(title: "Attention", message: "please check your email and password", actionTitle: "OK")
                print(error.localizedDescription)
            } else if let loginData = loginData {
                print(loginData.token)
                UserDefaultsManager.shared().token = loginData.token
                UserDefaultsManager.shared().id = loginData.user.id

                self.goToMainVC()
            }
            self.view.hideLoader()
        }
        
    }
    
    //     MARK:- Private Methods
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
   
    private func goToMainVC() {
        let toDoListVC =  TodoListVC.create()
        let toDoListNav = UINavigationController(rootViewController: toDoListVC)
        AppDelegate.shared().window?.rootViewController = toDoListNav
    }
    
}
