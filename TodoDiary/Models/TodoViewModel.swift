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
    
    @Published var unpinnedTodos = Todo.unpinnedTodos()
    @Published var pinnedTodos = Todo.pinnedTodos()
    @Published var achievedTodos = Todo.achievedTodos()
    
    var token: NotificationToken? = nil
        
    init() {
        let realm = Todo.customRealm()
        token = realm.observe { (notification, realm) in
            withAnimation {
                self.unpinnedTodos = Todo.unpinnedTodos()
                self.pinnedTodos = Todo.pinnedTodos()
                self.achievedTodos = Todo.achievedTodos()
            }
        }
    }

    deinit {
        token?.invalidate()
    }
}
