//
//  TaskCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/5/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol deleteTaskDelegate: AnyObject {
    func deleteTask(cell: UITableViewCell)
}

class TaskCell: UITableViewCell {
    
    weak var delegate: deleteTaskDelegate?
    
    //MARK:- IBOutlets
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.deleteTask(cell: self)
    }
    
    func configureCell(task: String) {
        taskDescriptionLabel.text = task
    }
    
}
