//
//  todoContextMenu.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/14.
//

import SwiftUI

struct TodoContextMenuItems: View {
    
    let todoId: Int
    let isPinned: Bool
    let isAchieved: Bool
    
    @State var isShowDialog = false
    
    var body: some View {
        Group {
            //固定ボタン
            if !isAchieved && !isPinned {
                Button(action: {
                    Todo.pinTodo(id: todoId)
                }){
                    Label("固定する", systemImage: "pin")
                }
            }
            
            //固定解除ボタン
            if !isAchieved && isPinned {
                Button(action: {
                    Todo.unpinTodo(id: todoId)
                }){
                    Label("固定を解除", systemImage: "pin.slash")
                }
            }
            
            //達成ボタン
            if !isAchieved {
                Button(action: {
                    Todo.achieveTodo(id: todoId, achievedDate: Date())
                }){
                    Label("達成済みに変更", systemImage: "checkmark")
                }
            }
            
            //達成解除ボタン
            if isAchieved {
                Button(action: {
                    Todo.unachieveTodo(id: todoId)
                }){
                    Label("未達成に戻す", systemImage: "xmark")
                }
            }
            
            //削除ボタン
            Button(role: .destructive) {
                isShowDialog.toggle()
            } label: {
                Label("削除", systemImage: "trash")
            }
            
            .confirmationDialog("", isPresented: $isShowDialog, titleVisibility: .hidden) {
                Button("Todoを削除", role: .destructive) {
                    Todo.deleteTodo(id: todoId)
                }
            } message: {
                Text("このTodoを削除してもよろしいですか?").bold()
            }
        }
        
        
        
    }
}
