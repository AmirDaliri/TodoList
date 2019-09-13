//
//  SubTodo.swift
//  TestTodoList_Realm
//
//  Created by Amir Daliri on 9/13/19.
//  Copyright © 2019 Amir Daliri. All rights reserved.
//

import RealmSwift

class TodoList: Object {
    
    @objc dynamic var subject = ""
    @objc dynamic var createdAt = NSDate()
    let todos = List<Todo>()
}
