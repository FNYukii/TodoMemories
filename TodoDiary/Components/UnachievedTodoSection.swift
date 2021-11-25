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
                    Button(action: {
                        selectedTodoId = todo.id
                        isShowSheet.toggle()
                    }) {
                        HStack {
                            Text("\(todo.order)")
                                .foregroundColor(.secondary)
                            Text(todo.content)
                        }
                    }
                    .foregroundColor(.primary)
                    .contextMenu {
                        UnachievedTodoContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                    }
                }
                .onMove {sourceIndexSet, destination in
                    Todo.sortTodos(todos: todos, sourceIndexSet: sourceIndexSet, destination: destination)
                    editProtocol.reloadTodos()
                }
                .onDelete {indexSet in
                    indexSet.sorted(by: > ).forEach { (i) in
                        selectedTodoId = todos[i].id
                    }
                    isShowActionSheet.toggle()
                }
            }
        } else {
            Section {
                ForEach(todos.freeze()) { todo in
                    Button("\(todo.content)"){
                        selectedTodoId = todo.id
                        isShowSheet.toggle()
                    }
                    .foregroundColor(.primary)
                    .contextMenu {
                        UnachievedTodoContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                    }
                }
                .onMove {sourceIndexSet, destination in
                    Todo.sortTodos(todos: todos, sourceIndexSet: sourceIndexSet, destination: destination)
                    editProtocol.reloadTodos()
                }
                .onDelete {indexSet in
                    indexSet.sorted(by: > ).forEach { (i) in
                        selectedTodoId = todos[i].id
                    }
                    isShowActionSheet.toggle()
                }
            }
        }
    }
}
