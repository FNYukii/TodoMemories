//
//  Todo.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/16.
//

import Foundation
import RealmSwift

class Todo: Object, Identifiable {
    
    @objc dynamic var id = 0
    @objc dynamic var content = ""
    @objc dynamic var isPinned = false
    @objc dynamic var isAchieved = false
    @objc dynamic var achievedDate = Date()
    
    static func all() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self)
    }
    
    static func pinnedTodos() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isPinned == true")
    }
    
    static func unpinnedTodos() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isPinned == false")
    }
    
}
