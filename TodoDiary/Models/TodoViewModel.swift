//
//  TodoViewModel.swift
//  TodoDiary
//
//  Created by Yu on 2022/02/12.
//

import Foundation
import RealmSwift
import SwiftUI

class TodoViewModel: ObservableObject {
    
    @Published var todos = Todo.noRecord()
    
    var token: NotificationToken? = nil
    
    init(isAchieved: Bool = false, isPinned: Bool = false) {
        
        if !isAchieved && isPinned {
            self.todos = Todo.pinnedTodos()
        }
        if !isAchieved && !isPinned {
            self.todos = Todo.unpinnedTodos()
        }
        
        let realm = Todo.customRealm()
        token = realm.observe { (notification, realm) in
            withAnimation {
                if !isAchieved && isPinned {
                    self.todos = Todo.pinnedTodos()
                }
                if !isAchieved && !isPinned {
                    self.todos = Todo.unpinnedTodos()
                }
            }
        }
    }
    
    deinit {
        token?.invalidate()
    }
}
