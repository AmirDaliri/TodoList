//
//  Todo.swift
//  TestTodoList_Realm
//
//  Created by Amir Daliri on 9/13/19.
//  Copyright © 2019 Amir Daliri. All rights reserved.
//

import RealmSwift

class Todo: Object {
    
    @objc dynamic var subject = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var notes = ""
    @objc dynamic var isFinished = false
}
