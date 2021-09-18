//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct SecondView: View, MyProtocol {
    
    @State var todos = Todo.achievedTodos()
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            
            Form {
                ForEach(todos.freeze()){ todo in
                    Button("\(todo.content)"){
                        selectedTodoId = todo.id
                        isShowSheet.toggle()
                    }
                    .foregroundColor(.primary)
                }
            }
            .onAppear {
                reloadRecords()
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(myProtocol: self)
            }
            
            .navigationBarTitle("完了済み")
        }
    }
    
    func reloadRecords() {
        todos = Todo.achievedTodos()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
