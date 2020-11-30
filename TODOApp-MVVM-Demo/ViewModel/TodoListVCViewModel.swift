//
//  TodoListVCPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/25/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

protocol ToDoListViewModelProtocol {
    func getTasks()
    func taskCount() -> Int
    func configure(cell: TaskCell, for index: Int)
    func deleteTaskAlert(index: Int)
}

class TodoListVCViewModel {
    
    //MARK:- Properties
    weak var view: ToDoListProtocol!
    var tasks = [TaskData]()
    
    //MARK:- LifeCycleMethods
    init(view: ToDoListProtocol) {
        self.view = view
    }
    
    //MARK:- Private Methods
    private func deleteTask(index: Int) {
        self.view.showLoader()
        let id = tasks[index].id
        APIManager.deleteTask(by: id) { (success) in
            if success {
                self.getTasks()
                print("task deleted")
            } else {
                print("task NOT deleted")
            }
            self.view.hideLoader()
        }
    }
    
}
//MARK:- Protocol Methods
extension TodoListVCViewModel: ToDoListViewModelProtocol {
    
    func getTasks() {
        self.view.showLoader()
        APIManager.getTask { (result) in
            switch result {
            case .success(let taskData):
                self.tasks = taskData.data
                self.view.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            self.view.hideLoader()
        }
    }
    
    func taskCount() -> Int {
        return tasks.count
    }
    
    func configure(cell: TaskCell, for index: Int) {
        let task = tasks[index]
        cell.taskDescriptionLabel.text = task.description
    }
    
    func deleteTaskAlert(index: Int) {
        self.view.showAlert(title: "Delete task", message: "are you sure u wanna delete this task ?", alertStyle: .alert, actionTitles: ["yes", "cancel"], actionStyles: [.destructive, .default], actions: [{ action in
            self.deleteTask(index: index)
            },nil])
        
    }
}
