//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View {
    
    @Environment(\.editMode) var editMode
    
    @ObservedObject var pinnedTodoViewModel = TodoViewModel(isPinned: true)
    @ObservedObject var unpinnedTodoViewModel = TodoViewModel()
    
    @State var isShowCreateSheet = false
    @State var isShowEditSheet = false
    @State var isShowActionSheet = false
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    
                    if pinnedTodoViewModel.todos.count != 0 {
                        Section(header: Text("固定済み")) {
                            ForEach(pinnedTodoViewModel.todos.freeze()) { todo in
                                Button(todo.content) {
                                    selectedTodoId = todo.id
                                    isShowEditSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu {
                                    TodoContextMenuItems(todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                                }
                                .sheet(isPresented: $isShowEditSheet) {
                                    EditView(todo: todo)
                                }
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: pinnedTodoViewModel.todos, sourceIndexSet: sourceIndexSet, destination: destination)
                            }
                        }
                    }
                    
                    if unpinnedTodoViewModel.todos.count != 0 {
                        Section(header: pinnedTodoViewModel.todos.count == 0 ? nil : Text("その他")) {
                            ForEach(unpinnedTodoViewModel.todos.freeze()) { todo in
                                Button(todo.content) {
                                    selectedTodoId = todo.id
                                    isShowEditSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu {
                                    TodoContextMenuItems(todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                                }
                                .sheet(isPresented: $isShowEditSheet) {
                                    EditView(todo: todo)
                                }
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: unpinnedTodoViewModel.todos, sourceIndexSet: sourceIndexSet, destination: destination)
                            }
                        }
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                
                if pinnedTodoViewModel.todos.count == 0 && unpinnedTodoViewModel.todos.count == 0 {
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
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload FirstView")
    }
}
