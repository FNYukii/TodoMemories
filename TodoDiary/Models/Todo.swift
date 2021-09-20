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
    @objc dynamic var achievedYmd = 0
    
    //realmインスタンス
    static func customRealm() -> Realm {
        var realm: Realm {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.example.y.TodoDiary")!
            config.fileURL = url.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }
        return realm
    }
    
    //全てのレコード
    static func all() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self)
    }
    
    //未達成Todo
    static func unachievedTodos() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isAchieved == false").sorted(byKeyPath: "id", ascending: false)
    }
    
    //固定済み未達成Todo
    static func pinnedTodos() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isPinned == true && isAchieved == false").sorted(byKeyPath: "id", ascending: false)
    }
    
    //未固定未達成Todo
    static func unpinnedTodos() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isPinned == false && isAchieved == false").sorted(byKeyPath: "id", ascending: false)
    }
    
    //達成済みTodo
    static func achievedTodos() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isAchieved == true").sorted(byKeyPath: "achievedDate", ascending: false)
    }
    
    //0件の結果
    static func noRecord() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("id == -1")
    }
    
}
