//
//  unachievedTodosSection.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/15.
//

import SwiftUI
import RealmSwift

struct TodoSection: View {
    
    var editProtocol: EditProtocol
    let todos: Results<Todo>
    let headerText: String
    @Binding var isShowActionSheet: Bool
    @Binding var selectedTodoId: Int
    @Binding var isShowSheet: Bool
        
    var body: some View {
        if headerText.isEmpty {
            Section {
                TodoSectionForEach(editProtocol: editProtocol, todos: todos, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)

            }
        }
        if !headerText.isEmpty{
            Section(header: Text(headerText)) {
                TodoSectionForEach(editProtocol: editProtocol, todos: todos, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)
            }
        }
    }
}

struct TodoSectionForEach: View {
    
    var editProtocol: EditProtocol
    let todos: Results<Todo>
    @Binding var isShowActionSheet: Bool
    @Binding var selectedTodoId: Int
    @Binding var isShowSheet: Bool
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        ForEach(todos.freeze()) { todo in
            Button(todo.content) {
                selectedTodoId = todo.id
                isShowSheet.toggle()
            }
            .foregroundColor(.primary)
            .contextMenu {
                TodoContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
            }
            .deleteDisabled(editMode?.wrappedValue.isEditing == false)
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
