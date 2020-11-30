//
//  PopUpVCPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 12/1/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

protocol popUpViewModelProtocol {
    func addTask(with task: Task)
}

class PopUpViewModel {
    
    //MARK:- Properties
    weak var view: popUpProtocol!
    
    //MARK:- LifeCycleMethods
    init(view: popUpProtocol) {
        self.view = view
    }
}

extension PopUpViewModel: popUpViewModelProtocol {
    func addTask(with task: Task) {
        self.view.showLoader()
        APIManager.addTask(with: task) { (succeed) in
            if succeed {
                print("success")
                self.view.dismissVC()
                
            } else {
                print("failed")
            }
            self.view.hideLoader()
        }
    }
}
