//
//  ViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    var tasks = [TaskData]()
    
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        getAllTasks()
        
    }
    
    //MARK:- IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let popUpVC = PopupVCViewController.create()
        popUpVC.delegate = self
        self.present(popUpVC, animated: true)
    }
    
    
    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        return todoListVC
    }
    
    //MARK:- Private Methods
    private func getAllTasks() {
        self.view.showLoader()
        APIManager.getTask { (error, taskData) in
            if let error = error {
                print(error.localizedDescription)
            } else if let taskData = taskData {
                self.tasks = taskData
                self.tableView.reloadData()
            }
            self.view.hideLoader()
        }
    
    }
    private func tableViewConfigure() {
        tableView.register(UINib(nibName: Cells.taskCell, bundle: nil), forCellReuseIdentifier: Cells.taskCell)
        tableView.delegate = self
        tableView.dataSource = self

    }
}

extension TodoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.taskCell, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.configureCell(task: tasks[indexPath.row].description)
        return cell

    }
}

extension TodoListVC: sendingDescriptionDelegate {
    func refreshData() {
        getAllTasks()
    }
    
    
}
