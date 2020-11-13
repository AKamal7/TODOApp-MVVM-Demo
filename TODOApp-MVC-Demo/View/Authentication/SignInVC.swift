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
    
    //MARK:- Properties
    var presenter: SignInVCPresenter!
    
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
        let user = User(email: emailTextField.text, password: passwordTextField.text)
        if presenter.validateUser(with: user) {
             presenter.login(with: user)
        }
       
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        signInVC.presenter = SignInVCPresenter(view: signInVC)
        return signInVC
    }
    
}

//MARK:- SignIn Presenter Delegate
extension SignInVC: SignInView {
    func showAlert(title: String, message: String) {
        self.showAlert(title: title, message: message, actionTitle: "OK")
    }
    
    func goToMainVC() {
        let toDoListVC =  TodoListVC.create()
        let toDoListNav = UINavigationController(rootViewController: toDoListVC)
        AppDelegate.shared().window?.rootViewController = toDoListNav
    }
    
    
    func hideLoader() {
        self.view.hideLoader()
    }
    
    func showLoader() {
        self.view.showLoader()
    }
    
    
}
