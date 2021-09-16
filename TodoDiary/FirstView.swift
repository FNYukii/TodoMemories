//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View, MyProtocol {
    
    @State var isShowSheet = false
    
    @State var pinnedTodos = Todo.pinnedTodos()
    @State var unpinnedTodos = Todo.unpinnedTodos()
    
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            
            Form {
                
                if pinnedTodos.count != 0 {
                    Section(header: Text("固定済み")) {
                        ForEach(pinnedTodos.freeze()) { todo in
                            Button("\(todo.content)"){
                                selectedTodoId = todo.id
                                isShowSheet.toggle()
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                if unpinnedTodos.count != 0 && pinnedTodos.count != 0 {
                    Section(header: Text("その他")) {
                        ForEach(unpinnedTodos.freeze()) { todo in
                            Button("\(todo.content)"){
                                selectedTodoId = todo.id
                                isShowSheet.toggle()
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                if unpinnedTodos.count != 0 && pinnedTodos.count == 0 {
                    ForEach(unpinnedTodos.freeze()) { todo in
                        Button("\(todo.content)"){
                            selectedTodoId = todo.id
                            isShowSheet.toggle()
                        }
                        .foregroundColor(.primary)
                    }
                }
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(myProtocol: self)
            }
            
            .navigationBarTitle("Todo")
            .navigationBarItems(trailing:
                Button(action: {
                    selectedTodoId = 0
                    isShowSheet.toggle()
                }){
                    Image(systemName: "plus.circle.fill")
                    Text("新しいTodo")
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
