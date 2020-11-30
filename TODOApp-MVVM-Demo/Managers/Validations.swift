//
//  Validations.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/25/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

class Validations {
    
    //MARK:- Singleton
    private static let sharedInstance = Validations()
    
    //MARK:- Public Methods
    class func shared() -> Validations {
        return Validations.sharedInstance
    }
    
    func isEmptyEmail(email: String?) -> Bool {
        guard let email = email?.trimmed, !email.isEmpty else {
            return false
        }
        return true
    }
    
    
    func isValidEmail(email: String?) -> Bool {
        let regEx =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        if !pred.evaluate(with: email) {
            return false
        }
        return true
    }
    
    func isValidPassword(password: String?) -> Bool {
        guard let password = password, !password.isEmpty, password.count >= 8 else {
            return false
        }
        return true
    }
    
    func isvalidName(name: String?) -> Bool {
        let regEx = "^[a-zA-Z- ]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        if name!.isEmpty || !pred.evaluate(with: name) {
            return false
        }
        return true
    }
    
    func isValidAge(age: Int) -> Bool {
         let ageString = String(age)
        if ageString.isEmpty || age <= 0 {
            return false
        }
    return true
    }
    
}
