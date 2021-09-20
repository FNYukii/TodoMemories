//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct FirstView: View, EditProtocol {
    
    @State var pinnedTodos = Todo.pinnedTodos()
    @State var unpinnedTodos = Todo.unpinnedTodos()
    
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

                }
                .onAppear {
                    reloadRecords()
                }
                
                if pinnedTodos.count == 0 && unpinnedTodos.count == 0 {
                    Text("まだTodoがありません")
                        .foregroundColor(.secondary)
                }
                
                Button("マイグレーション") {
                    migration()
                }
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(editProtocol: self)
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
    
    func migration() {
        print("migration started")
        
        //古いレコードを取得
        let realm = try! Realm()
        let oldRecords = realm.objects(Todo.self)
        
        for oldrecord in oldRecords {
            
            //新規レコード用のidを生成
            let customRealm = Todo.customRealm()
            let maxId = customRealm.objects(Todo.self).sorted(byKeyPath: "id").last?.id ?? 0
            let newId = maxId + 1
            //新規レコード生成
            let todo = Todo()
            todo.id = newId
            todo.content = oldrecord.content
            todo.isPinned = oldrecord.isPinned
            todo.isAchieved = oldrecord.isAchieved
            todo.achievedDate = oldrecord.achievedDate
            todo.achievedYmd = oldrecord.achievedYmd
            //新規レコード追加
            try! customRealm.write {
                customRealm.add(todo)
            }
            
        }
        
        
        
        
        print("migration done")
    }
    
}
