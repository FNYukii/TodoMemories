//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View, MyProtocol {
    
    @State var isShowSheet = false
    
    @State var todos = Todo.all()
    
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            
            Form {
                
                Section(header: Text("固定済み")) {
                    Text("ご飯食べる")
                    Text("バグ直す")
                }
                
                Section(header: Text("その他")) {
                    ForEach(todos.freeze()) { todo in
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
                    isShowSheet.toggle()
                }){
                    Image(systemName: "plus.circle.fill")
                    Text("新しいTodo")
                }
            
            )
            
        }
    }
    
    func reloadRecords()  {
        todos = Todo.all()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
