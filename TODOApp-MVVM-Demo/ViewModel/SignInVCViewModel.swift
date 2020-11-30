//
//  SignInPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/13/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

protocol SignInViewModelProtocol {
    func tryToLogin(with user: User)
}

class SignInVCViewModel {
    
  weak var view: SignInProtocol!
    
    init(view: SignInProtocol) {
        self.view = view
    }
    
    //MARK:- Methods
    // user Validation
    private func validateUser(with user: User) -> Bool {
        guard let email = user.email, Validations.shared().isEmptyEmail(email: email), Validations.shared().isValidEmail(email: email)
            else {
                self.view.showAlert(title: "email is wrong", message: "email should be ex: alex@gmail.com", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
                return false
        }
        guard let password = user.password, Validations.shared().isValidPassword(password: password)            else {
            self.view.showAlert(title: "password is wrong", message: "password should be 8 or more characters ", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
            return false
        }
        return true
    }
    
    // MARK:- API
    private func login(with user: User) {
        self.view?.showLoader()
        APIManager.login(with: user) { (result) in
            switch result {
            case .success(let loginData):
                print(loginData.token)
                UserDefaultsManager.shared().token = loginData.token
                UserDefaultsManager.shared().id = loginData.user.id
                
                self.view?.goToMainVC()
            case .failure(let error):
                self.view?.showAlert(title: "Attention", message: "please check your email and password", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil )
                print(error.localizedDescription)
            }
            self.view?.hideLoader()
        }
    }
}
extension SignInVCViewModel: SignInViewModelProtocol {
    func tryToLogin(with user: User) {
          if validateUser(with: user) {
              login(with: user)
          }
      }
}
