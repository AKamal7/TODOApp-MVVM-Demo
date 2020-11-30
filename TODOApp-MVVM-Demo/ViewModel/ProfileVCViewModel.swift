//
//  ProfileVCPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/20/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

protocol profilePresenterViewModel {
    func getUserData()
    func updateUserProfile(with user: User)
    func userLoggedOut()
    func logOutAlert()
    func uploadPic(image: Data)
    func getImage(id: String)
    func deselectRow(section: Int, row: Int)
}

class ProfileVCViewModel: profilePresenterViewModel {
    
    //MARK:- Properties
    weak var view: profileProtocol!
    
    //MARK:- Init
    init(view: profileProtocol) {
        self.view = view
    }
    
    //MARK:-  Methods
    func getUserData() {
        self.view.showLoader()
        APIManager.getUserData { (result) in
            switch result {
                
            case .success(let userData):
                self.view.userData(userData: userData)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            self.view.hideLoader()
        }
    }
    
    func updateUserProfile(with user: User) {
        self.view.showLoader()
        APIManager.updateUserData(with: user) { (success) in
            if success {
                self.getUserData()
                print("Updated")
            } else {
                print("failed to update")
            }
            self.view.hideLoader()
        }
    }
    
    func userLoggedOut() {
        self.view.showLoader()
        APIManager.logOut { (success) in
            if success {
                print("loggedOut")
                UserDefaultsManager.shared().token = nil
                UserDefaultsManager.shared().id = nil
                self.view.goToAuthState()
            } else {
                print("failedToLoggedOut")
            }
            self.view.hideLoader()
        }
    }
    
    func logOutAlert() {
        self.view.showAlert(title: "Logout", message: "do u wanna logout ?", alertStyle: .actionSheet, actionTitles: ["yes", "NO"], actionStyles: [.default, .destructive], actions: [ {yesAction in
            self.userLoggedOut()
            },nil])
    }
    
    
    func uploadPic(image: Data) {
        self.view.showLoader()
        APIManager.uploadImage(with: image) { (success) in
            if success {
                print("successful Upload")
                guard let id = UserDefaultsManager.shared().id else { return }
                self.getImage(id: id)
            } else {
                print("failed to upload")
            }
            self.view.hideLoader()
        }
    }
    
    func getImage(id: String) {
        self.view.showLoader()
        APIManager.getImage(userID: id) { (response) in
            switch response {
                
            case .success(let data):
                self.view.profilePicData(data: data)
            case .failure(let error):
                print(error.localizedDescription)
                self.view.setupProfileLabel()
            }
            
            if self.view.profileImgView().image == nil {
                self.view.setupProfileLabel()
            }
            self.view.hideLoader()
        }
    }
    
    func deselectRow(section: Int, row: Int) {
        switch (section, row) {
        case (0, 0):
            self.view.editProfileAlert()
        case (1, 3):
            self.logOutAlert()
        case (_, _):
            break
        }
    }
    
}
