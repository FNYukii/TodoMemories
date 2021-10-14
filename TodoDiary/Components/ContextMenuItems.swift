//
//  todoContextMenu.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/14.
//

import SwiftUI

struct ContextMenuItems: View {
    
    var editProtocol: EditProtocol
    
    let todoId: Int
    let isPinned: Bool
    let isAchieved: Bool
    
    var body: some View {
        Group {
            
            //固定ボタン
            if !isAchieved && !isPinned {
                Button(action: {
                    Todo.switchIsPinned(id: todoId)
                    editProtocol.reloadRecords()
                }){
                    Label("固定する", systemImage: "pin")
                }
            }
            
            //固定解除ボタン
            if !isAchieved && isPinned {
                Button(action: {
                    Todo.switchIsPinned(id: todoId)
                    editProtocol.reloadRecords()
                }){
                    Label("固定を解除", systemImage: "pin")
                }
            }
            
            //達成ボタン
            if !isAchieved {
                Button(action: {
                    Todo.switchIsAchieved(id: todoId)
                    editProtocol.reloadRecords()
                }){
                    Label("達成済みに変更", systemImage: "checkmark")
                }
            }
            
            //達成解除ボタン
            if isAchieved {
                Button(action: {
                    Todo.switchIsAchieved(id: todoId)
                    editProtocol.reloadRecords()
                }){
                    Label("未達成に戻す", systemImage: "checkmark")
                }
            }
            
            //削除ボタン
            Button(action: {
                Todo.deleteTodo(id: todoId)
                editProtocol.reloadRecords()
            }){
                Label("削除", systemImage: "trash")
            }
            
        }
    }
}
