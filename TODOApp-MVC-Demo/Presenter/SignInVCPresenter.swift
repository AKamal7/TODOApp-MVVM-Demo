//
//  SignInPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/13/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
 
// MARK:- SignInView Protocol
protocol SignInView: class {
    func showLoader()
    func hideLoader()
    func goToMainVC()
    func showAlert(title: String, message: String)
}

class SignInVCPresenter {
    
    weak var view: SignInView?
    
    init(view: SignInView) {
        self.view = view
    }
    
    //MARK:- Methods
    // user Validation
    func validateUser(with user: User) -> Bool {
        guard let email = user.email, email.isValidEmail()
            else {
                self.view?.showAlert(title: "email is wrong", message: "Email should be ex: alex@gmail.com")
                return false
        }
        guard let password = user.password, password.isValidPassword()
            else {
                self.view?.showAlert(title: "password is wrong", message: "password should be 8 or more characters ")
                return false
        }
    return true
    }
    // MARK:- API
    func login(with user: User) {
        self.view?.showLoader()
           APIManager.login(with: user) { (result) in
               switch result {
               case .success(let loginData):
                   print(loginData.token)
                   UserDefaultsManager.shared().token = loginData.token
                   UserDefaultsManager.shared().id = loginData.user.id
                   
                   self.view?.goToMainVC()
               case .failure(let error):
                   self.view?.showAlert(title: "Attention", message: "please check your email and password")
                   print(error.localizedDescription)
               }
               self.view?.hideLoader()
           }
           
       }
    
    
    
}
