//
//  ProfileVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/8/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    //MARK:- Properties
    let imagePicker = UIImagePickerController()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.profileVC)
        return profileVC
    }
    
    //MARK:- IBActions
    @IBAction func addProfilePic(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK:- Private Methods
    private func getUserData() {
        self.view.showLoader()
        APIManager.getUserData { (error, userData) in
            if let error = error {
                print(error.localizedDescription)
            } else if let userData = userData {
                self.getImage(id: userData.id)
                self.nameLabel.text = userData.name
                self.emailLabel.text = userData.email
                self.ageLabel.text = String(userData.age)
                self.getInitials(name: userData.name)
                self.updateUserProfile(email: userData.email, name: userData.name, age: userData.age)
            }
            self.view.hideLoader()
        }
    }
   
    private func updateUserProfile(email: String, name: String, age: Int) {
        self.view.showLoader()
        APIManager.updateUserData(with: email, name: name, age: age) { (success) in
            if success {

                print("Updated")
            } else {
                print("failed to update")
            }
            self.view.hideLoader()
        }
    }
    
    
    private func userLoggedOut() {
        self.view.showLoader()
        APIManager.logOut { (success) in
            if success {
                print("loggedOut")
                UserDefaultsManager.shared().token = nil
                UserDefaultsManager.shared().id = nil
                self.goToAuthState()
            } else {
                print("failedToLoggedOut")
            }
            self.view.hideLoader()
        }
    }
    
    private func goToAuthState() {
        let signInVC = SignInVC.create()
        let signInNav = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = signInNav
    }
    
    private func logOutAlert() {
        let alert = UIAlertController(title: "Log Out", message: "are you sure u wanna Log Out :( ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alert) in
            self.userLoggedOut()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        present(alert, animated: false)
    }
    
    
   private func editProfileAlert() {
        let alert = UIAlertController(title: "Edit Your Profile", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
    alert.textFields![0].placeholder = "Email"
    alert.textFields![0].keyboardType = UIKeyboardType.emailAddress
    alert.textFields![1].placeholder = "Name"
    alert.textFields![2].placeholder = "Age"
    alert.textFields![2].keyboardType = UIKeyboardType.numberPad

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            let name = alert.textFields![0]


        }

        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    private func getInitials(name: String) {
        let initials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!).") + "\($1.first!)" }
        profileLabel.text = initials
    }
    
    private func uploadPic(image: UIImage) {
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
    
    private func getImage(id: String) {
        self.view.showLoader()
        APIManager.getImage(userId: id) { (error, data) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                self.profileLabel.isHidden = true
                self.profilePicImageView.image = UIImage(data: data)
            }
            
            if self.profilePicImageView.image == nil {
                self.profileLabel.isHidden = false
            }
            self.view.hideLoader()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            editProfileAlert()
            print("X")
        case (1, 3):
            logOutAlert()
        case (_, _):
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
}

extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage {
            uploadPic(image: chosenImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
