//
//  String+Trimming.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/4/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValidEmail() -> Bool {
        let regEx =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        if self.isEmpty || !pred.evaluate(with: self)  {
            return false
        }
        return true
    }
    
    func isValidPassword() -> Bool {
        guard !self.isEmpty, self.count >= 8 else {
            return false
        }
        return true
    }
    
    func isvalidName() -> Bool {
        let regEx = "^[a-zA-Z- ]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        if  self.isEmpty || !pred.evaluate(with: self)  {
            
            return false
        }
        return true
    }
    func isValidAge() -> Bool {
        guard let ageInt = Int(self) else {return false}
        if self.isEmpty || ageInt <= 0 {
            return false
        }
        return true
    }
    
}
