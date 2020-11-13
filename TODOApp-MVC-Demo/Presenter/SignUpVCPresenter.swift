//
//  SignUpVCPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/13/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

protocol SignUpView: class {
    func showLoader()
    func hideLoader()
    func goToMainVC()
    func showAlert(title: String, message: String)
}

class SignUpVCPresenter {
    
    weak private var view: SignUpView?
    
    init(view: SignUpView ) {
        self.view = view
    }
    
    //MARK:- Validate User
    func validateUser(user: User) -> Bool {
          guard let email = user.email, email.isValidEmail()
                  else {
                      self.view?.showAlert(title: "email is Invalid", message: "Email should be ex: alex@gmail.com")
                      return false
              }
              guard let password = user.password, password.isValidPassword()
                  else {
                      self.view?.showAlert(title: "password is wrong", message: "password should be 8 or more characters ")
                      return false
              }
        guard let name = user.name, name.isvalidName()
            else {
                self.view?.showAlert(title: "Wrong Name", message: "Name Should be letters Only")
                return false
        }
        guard let age = user.age, String(age).isValidAge() else {
            self.view?.showAlert(title: "Wrong Age", message: "Age should be more than 0")
            return false
        }
        
        return true
    }
    
    //MARK:- API
     func register(with user: User) {
        self.view?.showLoader()
        APIManager.register(with: user) { (result)  in
            switch result {
                
            case .success(let signUpResponse):
                UserDefaultsManager.shared().token = signUpResponse.token
                UserDefaultsManager.shared().id = signUpResponse.user.id
                self.view?.goToMainVC()
                print(signUpResponse.user.email)
            case .failure(let error):
                self.view?.showAlert(title: "Name is Invalid", message: "Name shouldn't contain numbers or special characters")
                print(error.localizedDescription)
            }
            self.view?.hideLoader()
        }
    }
}
