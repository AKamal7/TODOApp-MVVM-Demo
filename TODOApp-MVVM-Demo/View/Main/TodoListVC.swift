//
//  ViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol ToDoListProtocol: class {
    func showLoader()
    func hideLoader()
    func reloadData()
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?)
}

class TodoListVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    var viewModel: ToDoListViewModelProtocol!
    weak var delegate: MainNavigationDelegate?
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        viewModel.getTasks()
    }
    
    //MARK:- IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let popUpVC = PopupVCViewController.create()
        popUpVC.delegate = self
        self.present(popUpVC, animated: true)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIBarButtonItem) {
        let profileVC = ProfileVC.create()
        profileVC.delegate = delegate
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        todoListVC.viewModel = TodoListVCViewModel(view: todoListVC)
        return todoListVC
    }
    
    //MARK:- Private Methods
    private func tableViewConfigure() {
        tableView.register(UINib(nibName: Cells.taskCell, bundle: nil), forCellReuseIdentifier: Cells.taskCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.taskCell, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        viewModel.configure(cell: cell, for: indexPath.row)
        return cell
        
    }
}

extension TodoListVC: refreshToDoListDelegate {
    func refreshData() {
        viewModel.getTasks()
    }
}

extension TodoListVC: deleteTaskDelegate {
    func deleteTask(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        viewModel.deleteTaskAlert(index: indexPath.row)
    }
    
}

extension TodoListVC: ToDoListProtocol {
    
    func showAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]?) {
        openAlert(title: title, message: message, alertStyle: alertStyle, actionTitles: actionTitles, actionStyles: actionStyles, actions: actions)
    }
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func showLoader() {
        self.view.showLoader()
    }
    
    func hideLoader() {
        self.view.hideLoader()
    }
    
}

