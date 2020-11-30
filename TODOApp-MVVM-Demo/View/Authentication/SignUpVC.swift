//
//  SignUpVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol signUpProtocol: class {
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?)
    func showLoader()
    func hideLoader()
    func goToMainVC()
}

class SignUpVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet var signUpView: SignUpView!
    
    //MARK:- Properties
    var presenter: SignUpPresenterViewModel!
    
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
        presenter.tryToSignUp(with: user)
        }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        signUpVC.presenter = SignUpVCViewModel(view: signUpVC)
        return signUpVC
    }
}

extension SignUpVC: signUpProtocol {
    
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style = .alert, actionTitles: [String] = ["ok"], actionStyles: [UIAlertAction.Style] = [UIAlertAction.Style.default], actions: [((UIAlertAction) -> Void)?]? = [nil]) {
        openAlert(title: title, message: message, alertStyle: alertStyle, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
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
