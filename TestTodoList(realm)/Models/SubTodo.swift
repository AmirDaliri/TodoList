//
//  SubTodo.swift
//  TestTodoList_Realm
//
//  Created by Amir Daliri on 9/13/19.
//  Copyright © 2019 Amir Daliri. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    
    @objc dynamic var subject = ""
    @objc dynamic var createdAt = NSDate()
    let tasks = List<Todo>()
}
