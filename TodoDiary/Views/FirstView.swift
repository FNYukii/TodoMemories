//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View {
    
    @Environment(\.editMode) var editMode
    
    @State var pinnedTodos = Todo.pinnedTodos()
    @State var unpinnedTodos = Todo.unpinnedTodos()
    
    @State var isShowCreateSheet = false
    @State var isShowEditSheet = false
    @State var isShowActionSheet = false
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    
                    if pinnedTodos.count != 0 {
                        Section(header: Text("固定済み")) {
                            ForEach(pinnedTodos.freeze()) { todo in
                                Button(todo.content) {
                                    selectedTodoId = todo.id
                                    isShowEditSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu {
                                    TodoContextMenuItems(todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                                }
                                .deleteDisabled(editMode?.wrappedValue.isEditing == false)
                                .sheet(isPresented: $isShowEditSheet) {
                                    EditView(todo: todo)
                                }
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: pinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                                reloadTodos()
                            }
                            .onDelete {indexSet in
                                indexSet.sorted(by: > ).forEach { (i) in
                                    selectedTodoId = pinnedTodos[i].id
                                }
                                isShowActionSheet.toggle()
                            }
                        }
                    }
                    
                    if unpinnedTodos.count != 0 {
                        Section(header: pinnedTodos.count == 0 ? nil : Text("その他")) {
                            ForEach(unpinnedTodos.freeze()) { todo in
                                Button(todo.content) {
                                    selectedTodoId = todo.id
                                    isShowEditSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu {
                                    TodoContextMenuItems(todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                                }
                                .deleteDisabled(editMode?.wrappedValue.isEditing == false)
                                .sheet(isPresented: $isShowEditSheet) {
                                    EditView(todo: todo)
                                }
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: unpinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                                reloadTodos()
                            }
                            .onDelete {indexSet in
                                indexSet.sorted(by: > ).forEach { (i) in
                                    selectedTodoId = unpinnedTodos[i].id
                                }
                                isShowActionSheet.toggle()
                            }
                        }
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear(perform: reloadTodos)
                
                if pinnedTodos.count == 0 && unpinnedTodos.count == 0 {
                    Text("まだTodoがありません")
                        .foregroundColor(.secondary)
                }
            }
            
            .sheet(isPresented: $isShowCreateSheet) {
                CreateView()
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
                leading: CustomEditButton(),
                trailing: Button(action: {
                    isShowCreateSheet.toggle()
                }){
                    Image(systemName: "plus.circle.fill")
                    Text("新しいTodo")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func reloadTodos()  {
        pinnedTodos = Todo.pinnedTodos()
        unpinnedTodos = Todo.unpinnedTodos()
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload FirstView")
    }
}
