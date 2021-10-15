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
                    
                    //固定済みTodo
                    if pinnedTodos.count != 0 {
                        UnachievedTodoSection(editProtocol: self, todos: pinnedTodos, headerText: "固定済み", isShowHeader: true, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)
                    }
                    //未固定Todo(固定済みTodoと共に表示)
                    if unpinnedTodos.count != 0 && pinnedTodos.count != 0 {
                        UnachievedTodoSection(editProtocol: self, todos: unpinnedTodos, headerText: "その他", isShowHeader: true, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)
                    }
                    //未固定Todo(単独表示)
                    if unpinnedTodos.count != 0 && pinnedTodos.count == 0 {
                        UnachievedTodoSection(editProtocol: self, todos: unpinnedTodos, headerText: "", isShowHeader: false, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId, isShowSheet: $isShowSheet)
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    loadData()
                }
                
                if pinnedTodos.count == 0 && unpinnedTodos.count == 0 {
                    Text("まだTodoがありません")
                        .foregroundColor(.secondary)
                }
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(editProtocol: self, id: $selectedTodoId)
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
                    selectedTodoId = 0
                    isShowSheet.toggle()
                }){
                    Label("新しいTodo", systemImage: "plus.circle.fill")
                }
            )
            
        }
    }
    
    func loadData()  {
        pinnedTodos = Todo.pinnedTodos()
        unpinnedTodos = Todo.unpinnedTodos()
    }

}
