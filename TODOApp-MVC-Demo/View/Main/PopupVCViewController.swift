//
//  PopupVCViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/5/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol refreshToDoListDelegate {
    func refreshData()
}

class PopupVCViewController: UIViewController {
    
    //MARK:- Properties
     var delegate: refreshToDoListDelegate?
    
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
        addTask(with: task)
        
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
        return popupVC
    }
    
    //MARK: Private Methods
    private func addTask(with task: Task) {
        self.view.showLoader()
        APIManager.addTask(with: task) { (succeed) in
            if succeed {
                print("success")
                // save the presenting ViewController
                let presentingViewController: UIViewController! = self.presentingViewController
                
                self.dismiss(animated: false) {
                    // go back to MainMenuView as the eyes of the user
                    presentingViewController.dismiss(animated: false, completion: nil)
                    self.delegate?.refreshData()
                    
                }
            } else {
                print("failed")
            }
            self.view.hideLoader()
        }
    }
}
