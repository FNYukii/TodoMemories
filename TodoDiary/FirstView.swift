//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View, MyProtocol {
    
    @State var pinnedTodos = Todo.pinnedTodos()
    @State var unpinnedTodos = Todo.unpinnedTodos()
    @State var achievedTodos = Todo.achievedTodos()
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Form {
                    //固定済みTodoが1件以上
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
                    //固定済みTodoと未固定Todo両方存在する
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
                    //未固定Todoしか存在しないならSectionHeaderのテキストは非表示
                    if unpinnedTodos.count != 0 && pinnedTodos.count == 0 {
                        ForEach(unpinnedTodos.freeze()) { todo in
                            Button("\(todo.content)"){
                                selectedTodoId = todo.id
                                isShowSheet.toggle()
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    //完了済みTodo
                    if achievedTodos.count != 0 {
                        Section(header: Text("完了済み")) {
                            ForEach(achievedTodos.freeze()) { todo in
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
                
                if pinnedTodos.count == 0 && unpinnedTodos.count == 0 && achievedTodos.count == 0 {
                    Text("まだTodoがありません")
                        .foregroundColor(.secondary)
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
        achievedTodos = Todo.achievedTodos()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
