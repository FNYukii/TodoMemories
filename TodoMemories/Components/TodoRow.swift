//
//  TodoRow.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import SwiftUI

struct TodoRow: View {
    
    let todo: Todo
    
    @State private var isShowEditSheet = false
    @State private var isConfirming = false
    
    var body: some View {
        Button(action: {
            isShowEditSheet.toggle()
        }) {
            HStack {
                if todo.isAchieved {
                    Text(DayConverter.toHmText(from: todo.achievedDate))
                        .foregroundColor(.secondary)
                }
                Text(todo.content)
                    .foregroundColor(.primary)
            }
        }
        
        .foregroundColor(.primary)
        .sheet(isPresented: $isShowEditSheet) {
            EditView(todo: todo)
        }
        
        .contextMenu {
            if !todo.isPinned && !todo.isAchieved {
                Button(action: {
                    Todo.pinTodo(id: todo.id)
                }) {
                    Label("pin", systemImage: "pin")
                }
            }
            
            if todo.isPinned && !todo.isAchieved {
                Button(action: {
                    Todo.unpinTodo(id: todo.id)
                }) {
                    Label("unpin", systemImage: "pin.slash")
                }
            }
            
            if !todo.isAchieved {
                Button(action: {
                    Todo.achieveTodo(id: todo.id, achievedDate: Date())
                }) {
                    Label("make_achieved", systemImage: "checkmark")
                }
            }
            
            if todo.isAchieved {
                Button(action: {
                    Todo.unachieveTodo(id: todo.id)
                }) {
                    Label("make_unachieved", systemImage: "xmark")
                }
            }
            
            Button(role: .destructive) {
                isConfirming.toggle()
            } label: {
                Label("delete", systemImage: "trash")
            }
        }
        
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            // Achieve
            if !todo.isAchieved {
                Button(action: {
                    Todo.achieveTodo(id: todo.id, achievedDate: Date())
                }) {
                    Image(systemName: "checkmark")
                }
                .tint(.accentColor)
            }
            // Unachieve
            if todo.isAchieved {
                Button(action: {
                    Todo.unachieveTodo(id: todo.id)
                }) {
                    Image(systemName: "xmark")
                }
                .tint(.accentColor)
            }
            // Pin
            if !todo.isPinned && !todo.isAchieved {
                Button(action: {
                    Todo.pinTodo(id: todo.id)
                }) {
                    Image(systemName: "pin")
                }
                .tint(.orange)
            }
            // Unpin
            if todo.isPinned && !todo.isAchieved {
                Button(action: {
                    Todo.unpinTodo(id: todo.id)
                }) {
                    Image(systemName: "pin.slash")
                }
                .tint(.orange)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(action: {
                isConfirming.toggle()
            }) {
                Image(systemName: "trash")
            }
            .tint(.red)
        }
        
        .confirmationDialog("are_you_sure_you_want_to_delete_this_todo", isPresented: $isConfirming, titleVisibility: .visible) {
            Button("delete_todo", role: .destructive) {
                Todo.deleteTodo(id: todo.id)
            }
        } message: {
            Text(todo.content)
        }
    }
}
