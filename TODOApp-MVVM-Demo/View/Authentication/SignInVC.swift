//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol AuthNavigationDelegate: class {
   func showMainState()
}

protocol SignInProtocol: class {
    func hideLoader()
    func showLoader()
    func goToMainVC()
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?)
}

class SignInVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var signInView: SignInView!
    
    //MARK:- Properties
    var viewModel: SignInViewModelProtocol!
    weak var delegate: AuthNavigationDelegate?
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signInView.setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        signUpVC.delegate = delegate
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let user = User(email: signInView.emailTextField.text, password: signInView.passwordTextField.text)
        viewModel.tryToLogin(with: user)
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        signInVC.viewModel = SignInVCViewModel(view: signInVC)
        return signInVC
    }
}

extension SignInVC: SignInProtocol {
    
     func showAlert(title: String, message: String, alertStyle: UIAlertController.Style = .alert, actionTitles: [String] = ["ok"], actionStyles: [UIAlertAction.Style] = [UIAlertAction.Style.default], actions: [((UIAlertAction) -> Void)?]? = [nil]) {
         openAlert(title: title, message: message, alertStyle: alertStyle, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
     }
     
     func goToMainVC() {
        self.delegate?.showMainState()
     }
     
     func hideLoader() {
         self.view.hideLoader()
     }
     
     func showLoader() {
         self.view.showLoader()
     }
}
