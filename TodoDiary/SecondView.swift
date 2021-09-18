//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct SecondView: View, MyProtocol {
    
    @State var todos = Todo.achievedTodos()
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
    @State var ymds: [Int] = [20210916, 20210916, 20210917]
    
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
                
                ForEach(0..<ymds.count) { index in
                    Section(header: Text("\(ymds[index])")) {
                        ForEach(getDailyTodos(achievedYmd: ymds[index]).freeze()){ todo in
                            Button("\(todo.content)"){
                                selectedTodoId = todo.id
                                isShowSheet.toggle()
                            }
                            .foregroundColor(.primary)
                        }
                    }
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
    
    func getDailyTodos(achievedYmd: Int) -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: false)
    }
    
    func reloadRecords() {
        todos = Todo.achievedTodos()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
