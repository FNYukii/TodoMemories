//
//  AchievedDaysViewModel.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import RealmSwift
import SwiftUI

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
        var days: [Day] = []
        var counter = 0
        for index in 0 ..< achievedTodos.count {
            // ループ初回。daysの最初の要素としてDayを追加
            if index == 0 {
                days.append(Day(ymd: DayConverter.toInt(from: achievedTodos[0].achievedDate), achievedTodos: []))
            }
            // ループ2回目以降。前回のachievedTodoの達成日と比較。違ったらdaysに新しいDayを追加
            if index > 0 {
                let prevAchievedYmd = DayConverter.toInt(from: achievedTodos[index - 1].achievedDate)
                let currentAchievedYmd = DayConverter.toInt(from: achievedTodos[index].achievedDate)
                if prevAchievedYmd != currentAchievedYmd {
                    counter += 1
                    days.append(Day(ymd: DayConverter.toInt(from: achievedTodos[index].achievedDate), achievedTodos: []))
                }
            }
            // Day.achievedTodosにachivedTodoを追加
            days[counter].achievedTodos.append(achievedTodos[index])
        }
        
        // プロパティに格納
        withAnimation {
            self.days = days
            self.isLoaded = true
        }
    }
    
    deinit {
        token?.invalidate()
    }
    
}
