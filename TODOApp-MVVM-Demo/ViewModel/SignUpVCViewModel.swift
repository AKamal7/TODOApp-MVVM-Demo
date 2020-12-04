//
//  SignUpVCPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/13/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

protocol SignUpViewModelProtocol {
    func tryToSignUp(with user: User)
}

class SignUpVCViewModel {
    
    weak private var view: signUpProtocol?
    
    init(view: signUpProtocol ) {
        self.view = view
    }
    
    //MARK:- Validate User
    private func validateUser(user: User) -> Bool {
        guard let email = user.email, Validations.shared().isEmptyEmail(email: email), Validations.shared().isValidEmail(email: email)
            else {
                self.view?.showAlert(title: "email is Invalid", message: "Email should be ex: alex@gmail.com", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
                return false
        }
        guard let password = user.password, Validations.shared().isValidPassword(password: password)
            else {
                self.view?.showAlert(title: "password is wrong", message: "password should be 8 or more characters ", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
                return false
        }
        guard let name = user.name, Validations.shared().isvalidName(name: name)
            else {
                self.view?.showAlert(title: "Wrong Name", message: "Name Should be letters Only", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
                return false
        }
        guard let age = user.age, Validations.shared().isValidAge(age: age)
            else {
                self.view?.showAlert(title: "Wrong Age", message: "Age should be more than 0", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
                return false
        }
        
        return true
    }
    
    //MARK:- API
    private func register(with user: User) {
        self.view?.showLoader()
        APIManager.register(with: user) { (result)  in
            switch result {
                
            case .success(let signUpResponse):
                UserDefaultsManager.shared().token = signUpResponse.token
                UserDefaultsManager.shared().id = signUpResponse.user.id
                self.view?.goToMainVC()
                print(signUpResponse.user.email)
            case .failure(let error):
                self.view?.showAlert(title: "check your email ", message: "this email is already registered", alertStyle: .alert, actionTitles: ["ok"], actionStyles: [.default], actions: [nil])
                print(error.localizedDescription)
            }
            self.view?.hideLoader()
        }
    }
}

extension SignUpVCViewModel: SignUpViewModelProtocol {
    
    func tryToSignUp(with user: User) {
        if validateUser(user: user) {
            register(with: user)
        }
    }
}
