//
//  Constants.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation


// Storyboards
struct Storyboards {
    static let authentication = "Authentication"
    static let main = "Main"
}

// View Controllers
struct ViewControllers {
    static let signUpVC = "SignUpVC"
    static let signInVC = "SignInVC"
    static let todoListVC = "TodoListVC"
    static let popupVC = "PopupVCViewController"
    static let profileVC = "ProfileVC"
}

// Urls
struct URLs {
    static let base = "https://api-nodejs-todolist.herokuapp.com"
    static let user = "/user"
    static let login = user + "/login"
    static let register = user + "/register"
    static let task = "/task"
    static let userData = user + "/me"
    static let userLogOut = user + "/logout"
    static let uploadImage = userData + "/avatar"
    
}

// Header Keys
struct HeaderKeys {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

// Parameters Keys
struct ParameterKeys {
    static let email = "email"
    static let password = "password"
    static let name = "name"
    static let age = "age"
    static let description = "description"
}

// UserDefaultsKeys
struct UserDefaultsKeys {
    static let token = "UDKToken"
    static let id = "id"
}

// Cells
struct Cells {
   static let taskCell = "TaskCell"
}
