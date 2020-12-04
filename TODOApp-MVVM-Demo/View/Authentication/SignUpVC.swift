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
    @IBOutlet var signUpView: SignUpView!
    
    //MARK:- Properties
    var viewModel: SignUpViewModelProtocol!
    weak var delegate: AuthNavigationDelegate?
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.setup()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let ageString = signUpView.ageTextField.text else { return }
        let age = Int(ageString)
        let user = User(email: signUpView.emailTextField.text, password: signUpView.passwordTextField.text, age: age , name: signUpView.nameTextField.text)
        viewModel.tryToSignUp(with: user)
        }
    
    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        signUpVC.viewModel = SignUpVCViewModel(view: signUpVC)
        return signUpVC
    }
}

extension SignUpVC: signUpProtocol {
    
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style = .alert, actionTitles: [String] = ["ok"], actionStyles: [UIAlertAction.Style] = [UIAlertAction.Style.default], actions: [((UIAlertAction) -> Void)?]? = [nil]) {
        openAlert(title: title, message: message, alertStyle: alertStyle, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
    }
     
     func goToMainVC() {
        self.delegate?.showMainState()
     }
     
     func showLoader() {
         self.view.showLoader()
     }
     
     func hideLoader() {
         self.view.hideLoader()
     }
}
