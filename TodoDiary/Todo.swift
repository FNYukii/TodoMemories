//
//  Todo.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/16.
//

import Foundation
import RealmSwift

class Todo: Object, Identifiable {
    
    //列定義
    @objc dynamic var id = 0
    @objc dynamic var content = ""
    @objc dynamic var isPinned = false
    @objc dynamic var isAchieved = false
    @objc dynamic var achievedDate = Date()
    
    //全てのレコード
    static func all() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self)
    }
    
    //固定済み未完了Todo
    static func pinnedTodos() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isPinned == true && isAchieved == false")
    }
    
    //未固定未完了Todo
    static func unpinnedTodos() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isPinned == false && isAchieved == false")
    }
    
    //完了済みTodo
    static func achievedTodos() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isAchieved == true")
    }
    
}
