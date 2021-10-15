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
    let isShowHeader: Bool
    
    @Binding var isShowActionSheet: Bool
    @Binding var selectedTodoId: Int
    @Binding var isShowSheet: Bool
    
    @Environment(\.editMode) var editMode
        
    var body: some View {
        
        if isShowHeader {
            Section(header: Text(headerText)) {
                ForEach(todos.freeze()) { todo in
                    Button(action: {
                        selectedTodoId = todo.id
                        isShowSheet.toggle()
                    }){
                        HStack {
                            if editMode?.wrappedValue.isEditing == true {
                                if todo.isPinned {
                                    Button(action: {
                                        Todo.unpinTodo(id: todo.id)
                                        editProtocol.loadData()
                                    }){
                                        Image(systemName: "arrow.down.circle")
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(.accentColor)
                                } else {
                                    Button(action: {
                                        Todo.pinTodo(id: todo.id)
                                        editProtocol.loadData()
                                    }){
                                        Image(systemName: "arrow.up.circle")
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(.accentColor)
                                }
                            }
                            Text("\(todo.content)")
                        }
                    }
                    .foregroundColor(.primary)
                    .contextMenu(ContextMenu(menuItems: {
                        ListContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                    }))
                }
                .onMove {sourceIndexSet, destination in
                    Todo.sortTodos(todos: todos, sourceIndexSet: sourceIndexSet, destination: destination)
                    editProtocol.loadData()
                }
//                .listRowInsets(EdgeInsets(top: 0, leading: -24, bottom: 0, trailing: 0))
            }
        } else {
            Section {
                ForEach(todos.freeze()) { todo in
                    Button(action: {
                        selectedTodoId = todo.id
                        isShowSheet.toggle()
                    }){
                        HStack {
                            if editMode?.wrappedValue.isEditing == true {
                                Button(action: {
                                    Todo.pinTodo(id: todo.id)
                                    editProtocol.loadData()
                                }){
                                    Image(systemName: "arrow.up.circle")
                                        .font(.system(size: 20))
                                }
                                .foregroundColor(.accentColor)
                            }
                            Text("\(todo.content)")
                        }
                    }
                    .foregroundColor(.primary)
                    .contextMenu(ContextMenu(menuItems: {
                        ListContextMenuItems(editProtocol: editProtocol, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                    }))
                }
                .onMove {sourceIndexSet, destination in
                    Todo.sortTodos(todos: todos, sourceIndexSet: sourceIndexSet, destination: destination)
                    editProtocol.loadData()
                }
//                .listRowInsets(EdgeInsets(top: 0, leading: -24, bottom: 0, trailing: 0))
            }
        }
        
    }
}
