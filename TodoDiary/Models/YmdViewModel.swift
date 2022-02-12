//
//  YmdViewModel.swift
//  TodoDiary
//
//  Created by Yu on 2022/02/12.
//

import Foundation
import RealmSwift

class YmdViewModel: ObservableObject {
    
    @Published var achievedYmds: [Int] = []
    
    var token: NotificationToken? = nil
    
    init() {
        
        loadAchievedYmds()
        
        let realm = Todo.customRealm()
        token = realm.observe { (notification, realm) in
            self.loadAchievedYmds()
        }
        
    }
    
    public func loadAchievedYmds() {
        let isAscending = UserDefaults.standard.bool(forKey: "isAscending")
        
        var ymds: [Int] = []
        let achievedTodos = Todo.achievedTodos()
        for achievedTodo in achievedTodos {
            ymds.append(achievedTodo.achievedYmd)
        }
        let orderedSet = NSOrderedSet(array: ymds)
        ymds = orderedSet.array as! [Int]
        if (isAscending) {
            ymds = ymds.reversed()
        }
        self.achievedYmds = ymds
    }
    
    deinit {
        token?.invalidate()
    }
}
