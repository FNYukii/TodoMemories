//
//  unachievedTodosSection.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/15.
//

import SwiftUI
import RealmSwift

struct UnachievedTodoSection: View {
    
    var editProtocol: EditProtocol
    
    let todos: Results<Todo>
    let headerText: String
    
    @Binding var isShowActionSheet: Bool
    @Binding var selectedTodoId: Int
    @Binding var isShowSheet: Bool
    
    @Environment(\.editMode) var editMode
        
    var body: some View {
        
        if !headerText.isEmpty {
            Section(header: Text(headerText)) {
                ForEach(todos.freeze()) { todo in
                    Text("\(todo.content)")
                    .foregroundColor(.primary)
                    .contextMenu {
                        UnachievedTodoContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)
                    }
                }
                .onMove {sourceIndexSet, destination in
                    Todo.sortTodos(todos: todos, sourceIndexSet: sourceIndexSet, destination: destination)
                    editProtocol.loadData()
                }
                .listRowInsets(EdgeInsets(top: 0, leading: -24, bottom: 0, trailing: 0))
            }
        } else {
            Section {
                ForEach(todos.freeze()) { todo in
                    Text("\(todo.content)")
                    .foregroundColor(.primary)
                    .contextMenu {
                        UnachievedTodoContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)
                    }
                }
                .onMove {sourceIndexSet, destination in
                    Todo.sortTodos(todos: todos, sourceIndexSet: sourceIndexSet, destination: destination)
                    editProtocol.loadData()
                }
                .listRowInsets(EdgeInsets(top: 0, leading: -24, bottom: 0, trailing: 0))
            }
        }
        
    }
}
