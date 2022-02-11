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
    
    @State var isShowCreateSheet = false
    @State var isShowEditSheet = false
    @State var isShowActionSheet = false
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    //固定済みTodo
                    if pinnedTodos.count != 0 {
                        TodoSection(editProtocol: self, todos: pinnedTodos, headerText: "固定済み", isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowEditSheet)
                    }
                    //未固定Todo(固定済みTodoと共に表示)
                    if unpinnedTodos.count != 0 && pinnedTodos.count != 0 {
                        TodoSection(editProtocol: self, todos: unpinnedTodos, headerText: "その他", isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowEditSheet)
                    }
                    //未固定Todo(単独表示)
                    if unpinnedTodos.count != 0 && pinnedTodos.count == 0 {
                        TodoSection(editProtocol: self, todos: unpinnedTodos, headerText: "", isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowEditSheet)
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
            
            .sheet(isPresented: $isShowEditSheet) {
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
    
    func todoId() -> Int {
        return selectedTodoId
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload FirstView")
    }
}
