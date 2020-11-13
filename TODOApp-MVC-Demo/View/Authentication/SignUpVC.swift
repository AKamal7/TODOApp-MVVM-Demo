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
    
    //MARK:- Properties
    var presenter: SignUpVCPresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let ageString = ageTextField.text else { return }
        let age = Int(ageString)
        let user = User(email: emailTextField.text, password: passwordTextField.text, age: age , name: nameTextField.text)
        if presenter.validateUser(user: user) {
           presenter.register(with: user)
        }
    }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        signUpVC.presenter = SignUpVCPresenter(view: signUpVC)
        return signUpVC
    }
    
}

//MARK:- SignUp Presenter Delegate
extension SignUpVC: SignUpView {
    func showAlert(title: String, message: String) {
        self.showAlert(title: title, message: message, actionTitle: "Ok")
    }
    
    func goToMainVC() {
        let toDoListVC =  TodoListVC.create()
        let toDoListNav = UINavigationController(rootViewController: toDoListVC)
        AppDelegate.shared().window?.rootViewController = toDoListNav
    }
    
    func showLoader() {
        self.view.showLoader()
    }
    
    func hideLoader() {
        self.view.hideLoader()
    }
    
}



