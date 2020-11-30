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
    
    let id: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case id = "_id"
    }
}



