//
//  Todo.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/16.
//

import Foundation
import RealmSwift

class Todo: Object, Identifiable {
    
    //列を定義
    @objc dynamic var id = 0
    @objc dynamic var content = ""
    @objc dynamic var isPinned = false
    @objc dynamic var isAchieved = false
    @objc dynamic var achievedDate = Date()
    
    //全てのレコードを返すメソッド
    static func all() -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self)
    }
    
}
