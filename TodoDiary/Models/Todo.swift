//
//  Todo.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/16.
//

import Foundation
import RealmSwift
import WidgetKit

class Todo: Object, Identifiable {
    
    //Todoの列定義
    @objc dynamic var id = 0
    @objc dynamic var order = 0
    @objc dynamic var content = ""
    @objc dynamic var isPinned = false
    @objc dynamic var isAchieved = false
    @objc dynamic var achievedDate = Date()
    @objc dynamic var achievedYmd = 0
    
    //realmインスタンス
    static func customRealm() -> Realm {
        var realm: Realm {
            var config = Realm.Configuration(
                //Realmデータベースのマイグレーションを行う
                schemaVersion: 5,
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                        //Do nothing
                    }
                }
            )
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
        return realm.objects(Todo.self).filter("isAchieved == false").sorted(byKeyPath: "order", ascending: true)
    }
    
    //固定済み未達成Todo
    static func pinnedTodos() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isPinned == true && isAchieved == false").sorted(byKeyPath: "order", ascending: true)
    }
    
    //未固定未達成Todo
    static func unpinnedTodos() -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isPinned == false && isAchieved == false").sorted(byKeyPath: "order", ascending: true)
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
        
    //新規Todo追加
    static func insertTodo(content: String, isPinned: Bool, isAchieved: Bool, achievedDate: Date) {
        let realm = Todo.customRealm()
        //新規レコード用のidを生成
        let maxId = realm.objects(Todo.self).sorted(byKeyPath: "id").last?.id ?? 0
        let newId = maxId + 1
        //新規レコード用のorderを生成
        let maxOrder = Todo.all().sorted(byKeyPath: "order").last?.order ?? 0
        let newOrder = maxOrder + 1
        //新規レコード生成
        let todo = Todo()
        todo.id = newId
        todo.order = newOrder
        todo.content = content
        todo.isPinned = isPinned
        todo.isAchieved = isAchieved
        todo.achievedDate = achievedDate
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: achievedDate)
        let month = calendar.component(.month, from: achievedDate)
        let day = calendar.component(.day, from: achievedDate)
        todo.achievedYmd = year * 10000 + month * 100 + day
        //新規レコード追加
        try! realm.write {
            realm.add(todo)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todo更新
    static func updateTodo(id: Int, content: String, isPinned: Bool, isAchieved: Bool, achievedDate: Date) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.content = content
            todo.isPinned = isPinned
            todo.isAchieved = isAchieved
            todo.achievedDate = achievedDate
            let calendar = Calendar(identifier: .gregorian)
            let year = calendar.component(.year, from: achievedDate)
            let month = calendar.component(.month, from: achievedDate)
            let day = calendar.component(.day, from: achievedDate)
            todo.achievedYmd = year * 10000 + month * 100 + day
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todo削除
    static func deleteTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            realm.delete(todo)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //TodoのisPinned設定
    static func switchIsPinned(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.isPinned = !todo.isPinned
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //TodoのisAchieved切り替え
    static func switchIsAchieved(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.isAchieved = !todo.isAchieved
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todoを並べ替え
    
}
