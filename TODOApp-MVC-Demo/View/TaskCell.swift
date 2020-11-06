//
//  TaskCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/5/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(task: String) {
        taskDescriptionLabel.text = task
    }
    
}
