//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct SecondView: View, MyProtocol {
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
    //Todoを完了した年月日の配列
    @State var achievedYmds: [Int] = []
    init() {
        _achievedYmds = State(initialValue: getAchievedYmds())
    }
    
    var body: some View {
        NavigationView {
            
            Form {
                
                ForEach(0..<achievedYmds.count) { index in
                    Section(header: Text("\(achievedYmds[index])")) {
                        ForEach(getDailyTodos(achievedYmd: achievedYmds[index]).freeze()){ todo in
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
    
    //Todo完了年月日の配列を生成する
    func getAchievedYmds() -> [Int] {
        var ymds: [Int] = []
        let achievedTodos = Todo.achievedTodos()
        for achievedTodo in achievedTodos {
            ymds.append(achievedTodo.achievedYmd)
        }
        let orderedSet = NSOrderedSet(array: ymds)
        ymds = orderedSet.array as! [Int]
        return ymds
    }
    
    //特定の年月日に完了したTodoを取得する
    func getDailyTodos(achievedYmd: Int) -> Results<Todo> {
        let realm = try! Realm()
        return realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: false)
    }
    
    func reloadRecords() {
        achievedYmds = getAchievedYmds()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
