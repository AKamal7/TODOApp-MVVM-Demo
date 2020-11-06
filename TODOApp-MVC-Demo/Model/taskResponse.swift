//
//  taskResponse.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/5/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct TaskResponse: Codable {
    let data: [TaskData]
}

struct TaskData: Codable {
    
    let description: String
}

