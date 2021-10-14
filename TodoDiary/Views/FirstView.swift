//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View, EditProtocol {
    
    @State var pinnedTodos = Todo.pinnedTodos()
    @State var unpinnedTodos = Todo.unpinnedTodos()
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    @State var isShowActionSheet = false
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                List {

                    //固定済みTodoが1件以上
                    if pinnedTodos.count != 0 {
                        Section(header: Text("固定済み")) {
                            ForEach(pinnedTodos.freeze()) { todo in
                                Button("\(todo.content) : \(todo.order)"){
                                    selectedTodoId = todo.id
                                    isShowSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu(ContextMenu(menuItems: {
                                    ListContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                                }))
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: pinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                                reloadRecords()
                            }
                        }
                    }
                    
                    //固定済みTodoと未固定Todo両方存在する
                    if unpinnedTodos.count != 0 && pinnedTodos.count != 0 {
                        Section(header: Text("その他")) {
                            ForEach(unpinnedTodos.freeze()) { todo in
                                Button("\(todo.content) : \(todo.order)"){
                                    selectedTodoId = todo.id
                                    isShowSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu(ContextMenu(menuItems: {
                                    ListContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                                }))
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: unpinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                                reloadRecords()
                            }
                        }
                    }
                    
                    //未固定Todoしか存在しないならSectionHeaderのテキストは非表示
                    if unpinnedTodos.count != 0 && pinnedTodos.count == 0 {
                        ForEach(unpinnedTodos.freeze()) { todo in
                            Button("\(todo.content) : \(todo.order)"){
                                selectedTodoId = todo.id
                                isShowSheet.toggle()
                            }
                            .foregroundColor(.primary)
                            .contextMenu(ContextMenu(menuItems: {
                                ListContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                            }))
                        }
                        .onMove {sourceIndexSet, destination in
                            Todo.sortTodos(todos: unpinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                            reloadRecords()
                        }
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    reloadRecords()
                }
                
                if pinnedTodos.count == 0 && unpinnedTodos.count == 0 {
                    Text("まだTodoがありません")
                        .foregroundColor(.secondary)
                }
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(editProtocol: self)
            }
            
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            Todo.deleteTodo(id: selectedTodoId)
                        },
                        .cancel()
                    ]
                )
            }
                        
            .navigationBarTitle("Todo")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    selectedTodoId = 0
                    isShowSheet.toggle()
                }){
                    Label("新しいTodo", systemImage: "plus.circle.fill")
                }
            )
            
        }
    }
    
    func reloadRecords()  {
        pinnedTodos = Todo.pinnedTodos()
        unpinnedTodos = Todo.unpinnedTodos()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }

}
