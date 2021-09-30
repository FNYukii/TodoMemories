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
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Form {
                    //固定済みTodoが1件以上
                    if pinnedTodos.count != 0 {
                        Section(header: Text("固定済み")) {
                            ForEach(pinnedTodos.freeze()) { todo in
                                Button("\(todo.content)"){
                                    editTodo(id: todo.id)
                                }
                                .foregroundColor(.primary)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action:{
                                        editTodo(id: todo.id)
                                    }){
                                        Text("編集")
                                        Image(systemName: "pencil")
                                    }
                                    Button(action: {
                                        unpinTodo(id: todo.id)
                                    }){
                                        Text("固定を外す")
                                        Image(systemName: "pin.slash")
                                    }
                                    Button(action: {
                                        achieveTodo(id: todo.id)
                                    }){
                                        Text("達成済みに変更")
                                        Image(systemName: "checkmark")
                                    }
                                    Button(action: {
                                        deleteTodo(id: todo.id)
                                    }){
                                        Text("削除")
                                        Image(systemName: "trash")
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
                                    Button(action:{
                                        editTodo(id: todo.id)
                                    }){
                                        Text("編集")
                                        Image(systemName: "pencil")
                                    }
                                    Button(action: {
                                        pinTodo(id: todo.id)
                                    }){
                                        Text("固定する")
                                        Image(systemName: "pin.fill")
                                    }
                                    Button(action: {
                                        achieveTodo(id: todo.id)
                                    }){
                                        Text("達成済みに変更")
                                        Image(systemName: "checkmark")
                                    }
                                    Button(action: {
                                        deleteTodo(id: todo.id)
                                    }){
                                        Text("削除")
                                        Image(systemName: "trash")
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
                                Button(action:{
                                    editTodo(id: todo.id)
                                }){
                                    Text("編集")
                                    Image(systemName: "pencil")
                                }
                                Button(action: {
                                    pinTodo(id: todo.id)
                                }){
                                    Text("固定する")
                                    Image(systemName: "pin.fill")
                                }
                                Button(action: {
                                    achieveTodo(id: todo.id)
                                }){
                                    Text("達成済みに変更")
                                    Image(systemName: "checkmark")
                                }
                                Button(action: {
                                    deleteTodo(id: todo.id)
                                }){
                                    Text("削除")
                                    Image(systemName: "trash")
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
    
    func editTodo(id: Int) {
        selectedTodoId = id
        isShowSheet.toggle()
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
            todo.isAchieved = true
            let converter = Converter()
            todo.achievedYmd = converter.toYmd(inputDate: Date())
        }
        reloadRecords()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func deleteTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            realm.delete(todo)
        }
        reloadRecords()
        WidgetCenter.shared.reloadAllTimelines()
    }

}
