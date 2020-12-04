//
//  PopupVCViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/5/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol refreshToDoListDelegate: class {
    func refreshData()
}

protocol popUpProtocol: class {
    func showLoader()
    func hideLoader()
    func dismissVC() 
}

class PopupVCViewController: UIViewController {
    
    //MARK:- Properties
    weak var delegate: refreshToDoListDelegate?
    var viewModel: popUpViewModelProtocol!
    //MARK:- IBOutlets
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- IBActions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let descriptionText = descriptionTextField.text else {
            return
        }
        let task = Task(description: descriptionText)
        viewModel.addTask(with: task)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        // save the presenting ViewController
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismiss(animated: false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK:- Public Methods
    class func create() -> PopupVCViewController {
        let popupVC: PopupVCViewController = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.popupVC)
        popupVC.viewModel = PopUpViewModel(view: popupVC)
        return popupVC
    }
}

//MARK:- Protocol Methods
extension PopupVCViewController: popUpProtocol {
    func showLoader() {
        self.view.showLoader()
    }
    
    func hideLoader() {
        self.view.hideLoader()
        
    }
    
    func dismissVC() {
        self.dismiss(animated: false) {
            self.delegate?.refreshData()
        }
    }
    
}
