//
//  AchievedDaysViewModel.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import Foundation
import RealmSwift

class AchievedDaysViewModel: ObservableObject {
    
    @Published var days: [Day] = []
    @Published var isLoaded = false
    
    var token: NotificationToken? = nil
    
    init() {
        loadDays()
        
        // Realmデータベースに変更があった場合
        let realm = Todo.customRealm()
        token = realm.observe { (notification, realm) in
            self.loadDays()
        }
    }
    
    private func loadDays() {
        
        // 全ての達成済みTodoを取得
        let achievedTodos = Array(Todo.achievedTodos())
        
        // 配列daysを生成
        
        
        // プロパティに格納
        
    }
    
    deinit {
        token?.invalidate()
    }
    
}
