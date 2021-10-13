//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift
import WidgetKit

struct FirstView: View, EditProtocol {
    
    @State var pinnedTodos = Todo.pinnedTodos()
    @State var unpinnedTodos = Todo.unpinnedTodos()
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    @State var isShowActionSheet = false
    
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
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action: {
                                        unpinTodo(id: todo.id)
                                    }){
                                        Label("固定を外す", systemImage: "pin.slash")
                                    }
                                    Button(action: {
                                        achieveTodo(id: todo.id)
                                    }){
                                        Label("達成済みに変更", systemImage: "checkmark")
                                    }
                                    Button(action: {
                                        selectedTodoId = todo.id
                                        isShowActionSheet.toggle()
                                    }){
                                        Label("削除", systemImage: "trash")
                                    }
                                }))
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
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action: {
                                        pinTodo(id: todo.id)
                                    }){
                                        Label("固定する", systemImage: "pin")
                                    }
                                    Button(action: {
                                        achieveTodo(id: todo.id)
                                    }){
                                        Label("達成済みに変更", systemImage: "checkmark")
                                    }
                                    Button(action: {
                                        selectedTodoId = todo.id
                                        isShowActionSheet.toggle()
                                    }){
                                        Label("削除", systemImage: "trash")
                                    }
                                }))
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
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    pinTodo(id: todo.id)
                                }){
                                    Label("固定する", systemImage: "pin")
                                }
                                Button(action: {
                                    achieveTodo(id: todo.id)
                                }){
                                    Label("達成済みに変更", systemImage: "checkmark")
                                }
                                Button(action: {
                                    selectedTodoId = todo.id
                                    isShowActionSheet.toggle()
                                }){
                                    Label("削除", systemImage: "trash")
                                }
                            }))
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
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(editProtocol: self)
            }
            
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            deleteTodo()
                        },
                        .cancel()
                    ]
                )
            }
            
            .navigationBarTitle("Todo")
            .navigationBarItems(trailing:
                Button(action: {
                    selectedTodoId = 0
                    isShowSheet.toggle()
                }){
                    Label("新しいTodo", systemImage: "plus.circle.fill")
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
    
    func pinTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.isPinned = true
        }
        reloadRecords()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func unpinTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.isPinned = false
        }
        reloadRecords()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func achieveTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.isPinned = false
            todo.isAchieved = true
            todo.achievedDate = Date()
            let converter = Converter()
            todo.achievedYmd = converter.toYmd(inputDate: Date())
        }
        reloadRecords()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func deleteTodo() {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(selectedTodoId)").first!
        try! realm.write {
            realm.delete(todo)
        }
        reloadRecords()
        WidgetCenter.shared.reloadAllTimelines()
    }

}
