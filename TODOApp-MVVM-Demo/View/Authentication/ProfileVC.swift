//
//  ProfileVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/8/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol profileProtocol: class {
    func showLoader()
    func hideLoader()
    func userData(userData: UserData)
    func profilePicData(data: Data)
    func setupProfileLabel()
    func profileImgView() -> UIImageView
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?)
    func goToAuthState()
    func editProfileAlert()
}

class ProfileVC: UITableViewController {
    
    var presenter: profilePresenterViewModel!
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
        presenter.getUserData()
    }
    
    //MARK:- IBActions
    @IBAction func addProfilePic(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.profileVC)
        profileVC.presenter = ProfileVCViewModel(view: profileVC)
        return profileVC
    }
    
    //MARK:- Private Methods
    private func getInitials(name: String) {
        let initials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!).") + "\($1.first!)" }
        profileLabel.text = initials
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.deselectRow(section: indexPath.section, row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage, let imageData = chosenImage.jpegData(compressionQuality: 0.8) {
            presenter.uploadPic(image: imageData )
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC: profileProtocol {
    
    func userData(userData: UserData) {
        presenter.getImage(id: userData.id)
        self.nameLabel.text = userData.name
        self.emailLabel.text = userData.email
        self.ageLabel.text = String(userData.age)
        self.getInitials(name: userData.name)
    }
    
    func showLoader() {
        self.view.showLoader()
    }
    
    func hideLoader() {
        self.view.hideLoader()
    }
    
    func profilePicData(data: Data) {
        self.profileLabel.isHidden = true
        self.profilePicImageView.image = UIImage(data: data)
    }
    
    func setupProfileLabel() {
        self.profileLabel.isHidden = false
    }
    
    func profileImgView() -> UIImageView {
        return profilePicImageView
    }
    
    func goToAuthState() {
        let signInVC = SignInVC.create()
        let signInNav = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = signInNav
    }
    
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?) {
        openAlert(title: title, message: message, alertStyle: alertStyle, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
    }
    
    private func logOutAlert(title: String, message: String, preferedStyle: UIAlertController.Style, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: "Log Out", message: "are you sure u wanna Log Out :( ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alert) in
            self.presenter.userLoggedOut()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        present(alert, animated: false)
    }
    
    func editProfileAlert() {
        let alert = UIAlertController(title: "Edit Your Profile", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.textFields![0].placeholder = "Email"
        alert.textFields![0].text = self.emailLabel.text
        alert.textFields![0].keyboardType = UIKeyboardType.emailAddress
        alert.textFields![1].placeholder = "Name"
        alert.textFields![1].text = self.nameLabel.text
        alert.textFields![2].placeholder = "Age"
        alert.textFields![2].keyboardType = UIKeyboardType.numberPad
        alert.textFields![2].text = self.ageLabel.text
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            guard let age = Int(alert.textFields![2].text ?? "") else {return}
            let user = User(email: alert.textFields![0].text,age: age, name: alert.textFields![1].text)
            self.presenter.updateUserProfile(with: user)
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
}
