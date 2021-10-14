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
    
    //指定されたidのTodo
    static func oneTodo(id: Int) -> Todo {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("id == \(id)").first!
    }
    
    //指定された年月日に達成されたTodo
    static func todosOfTheDay(achievedYmd: Int, isAscending: Bool) -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: isAscending)
    }
        
    
    //新規Todo追加
    static func insertTodo(content: String, isPinned: Bool, isAchieved: Bool, achievedDate: Date) {
        let realm = Todo.customRealm()
        //新規レコード用のidを生成
        let maxId = realm.objects(Todo.self).sorted(byKeyPath: "id").last?.id ?? 0
        let newId = maxId + 1
        //新規レコード用のorderを生成
        var newOrder = 0
        if !isAchieved {
            var maxOrder = 0
            if !isPinned {
                maxOrder = Todo.unpinnedTodos().sorted(byKeyPath: "order").last?.order ?? -1
            } else {
                maxOrder = Todo.pinnedTodos().sorted(byKeyPath: "order").last?.order ?? -1
            }
            newOrder = maxOrder + 1
        } else {
            newOrder = -1
        }
        //新規レコード生成
        let todo = Todo()
        todo.id = newId
        todo.order = newOrder
        todo.content = content
        todo.isPinned = isPinned
        todo.isAchieved = isAchieved
        if isAchieved {
            todo.achievedDate = achievedDate
            let calendar = Calendar(identifier: .gregorian)
            let year = calendar.component(.year, from: achievedDate)
            let month = calendar.component(.month, from: achievedDate)
            let day = calendar.component(.day, from: achievedDate)
            todo.achievedYmd = year * 10000 + month * 100 + day
        }
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
            if isAchieved {
                todo.achievedDate = achievedDate
                let calendar = Calendar(identifier: .gregorian)
                let year = calendar.component(.year, from: achievedDate)
                let month = calendar.component(.month, from: achievedDate)
                let day = calendar.component(.day, from: achievedDate)
                todo.achievedYmd = year * 10000 + month * 100 + day
            }
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
    
    //Todoを固定する
    static func pinTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        
        //選択されたTodo以外のunpinnedTodosのTodoのorderを調整
        let selectedOrder = todo.order
        let todos = Todo.unpinnedTodos()
        let unpinnedTodosMaxOrder = todos.sorted(byKeyPath: "order").last?.order ?? -1
        if selectedOrder != unpinnedTodosMaxOrder {
            for index in selectedOrder + 1 ... unpinnedTodosMaxOrder {
                Todo.changeOrder(id: todos[index].id, newOrder: todos[index].order - 1)
            }
        }
        
        //選択されたTodoを固定し、pinnedTodosの後尾に追加
        let maxOrder = Todo.pinnedTodos().sorted(byKeyPath: "order").last?.order ?? -1
        let newOrder = maxOrder + 1
        try! realm.write {
            todo.isPinned = true
            todo.order = newOrder
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todoの固定を解除する
    static func unpinTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        
        //選択されたTodo以外のpinnedTodosのTodoのorderを調整
        let selectedOrder = todo.order
        let todos = Todo.pinnedTodos()
        let pinnedTodosMaxOrder = todos.sorted(byKeyPath: "order").last?.order ?? -1
        if selectedOrder != pinnedTodosMaxOrder {
            for index in selectedOrder + 1 ... pinnedTodosMaxOrder {
                Todo.changeOrder(id: todos[index].id, newOrder: todos[index].order - 1)
            }
        }
        
        //選択されたTodoの固定を解除し、unPinnedTodosの後尾に追加
        let maxOrder = Todo.unpinnedTodos().sorted(byKeyPath: "order").last?.order ?? -1
        let newOrder = maxOrder + 1
        try! realm.write {
            todo.isPinned = false
            todo.order = newOrder
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todoを達成済みに変更する
    static func achieveTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        
        //選択されたTodo以外のTodoのorderを調整
        let selectedOrder = todo.order
        var todos = Todo.noRecord()
        if !todo.isPinned {
            todos = Todo.unpinnedTodos()
        } else {
            todos = Todo.pinnedTodos()
        }
        let todosMaxOrder = todos.sorted(byKeyPath: "order").last?.order ?? -1
        if selectedOrder != todosMaxOrder {
            for index in selectedOrder + 1 ... todosMaxOrder {
                Todo.changeOrder(id: todos[index].id, newOrder: todos[index].order - 1)
            }
        }
        
        //選択されたTodoを達成済みにする
        try! realm.write {
            todo.order = -1
            todo.isPinned = false
            todo.isAchieved = true
            todo.achievedDate = Date()
            let calendar = Calendar(identifier: .gregorian)
            let year = calendar.component(.year, from: Date())
            let month = calendar.component(.month, from: Date())
            let day = calendar.component(.day, from: Date())
            todo.achievedYmd = year * 10000 + month * 100 + day
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todoを未達成に戻す
    static func unachieveTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        let maxOrder = Todo.unpinnedTodos().sorted(byKeyPath: "order").last?.order ?? -1
        let newOrder = maxOrder + 1
        try! realm.write {
            todo.order = newOrder
            todo.isAchieved = false
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Todoのorderを変更する
    static func changeOrder(id: Int, newOrder: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.order = newOrder
        }
    }
    
    //Todoを並べ替え
    static func sortTodos(todos: Results<Todo>, sourceIndexSet: IndexSet, destination: Int) {
        guard let source = sourceIndexSet.first else {
            return
        }
        let moveId = todos[source].id
        if source < destination {
            print("down")
            for i in (source + 1)...(destination - 1) {
                Todo.changeOrder(id: todos[i].id, newOrder: todos[i].order - 1)
            }
            Todo.changeOrder(id: moveId, newOrder: destination - 1)
        }
        if destination < source {
            print("up")
            for i in (destination...(source - 1)).reversed() {
                Todo.changeOrder(id: todos[i].id, newOrder: todos[i].order + 1)
            }
            Todo.changeOrder(id: moveId, newOrder: destination)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
