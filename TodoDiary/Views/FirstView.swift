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
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                List {

                    //固定済みTodoが1件以上
                    if pinnedTodos.count != 0 {
                        Section(header: Text("固定済み")) {
                            ForEach(pinnedTodos.freeze()) { todo in
                                Button("\(todo.content) : \(todo.order)"){
                                    selectedTodoId = todo.id
                                    isShowSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu(ContextMenu(menuItems: {
                                    ContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved)
                                }))
                            }
                            .onMove {sourceIndexSet, destination in
                                sortTodos(todos: pinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                            }
                        }
                    }
                    
                    //固定済みTodoと未固定Todo両方存在する
                    if unpinnedTodos.count != 0 && pinnedTodos.count != 0 {
                        Section(header: Text("その他")) {
                            ForEach(unpinnedTodos.freeze()) { todo in
                                Button("\(todo.content) : \(todo.order)"){
                                    selectedTodoId = todo.id
                                    isShowSheet.toggle()
                                }
                                .foregroundColor(.primary)
                                .contextMenu(ContextMenu(menuItems: {
                                    ContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved)
                                }))
                            }
                            .onMove {sourceIndexSet, destination in
                                sortTodos(todos: unpinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                            }
                        }
                    }
                    
                    //未固定Todoしか存在しないならSectionHeaderのテキストは非表示
                    if unpinnedTodos.count != 0 && pinnedTodos.count == 0 {
                        ForEach(unpinnedTodos.freeze()) { todo in
                            Button("\(todo.content) : \(todo.order)"){
                                selectedTodoId = todo.id
                                isShowSheet.toggle()
                            }
                            .foregroundColor(.primary)
                            .contextMenu(ContextMenu(menuItems: {
                                ContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved)
                            }))
                        }
                        .onMove {sourceIndexSet, destination in
                            sortTodos(todos: unpinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                        }
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
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
                            Todo.deleteTodo(id: selectedTodoId)
                        },
                        .cancel()
                    ]
                )
            }
                        
            .navigationBarTitle("Todo")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
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
    
    func sortTodos(todos: Results<Todo>, sourceIndexSet: IndexSet, destination: Int) {
        guard let source = sourceIndexSet.first else {
            return
        }
        let realm = Todo.customRealm()
        let moveId = todos[source].id
        if source < destination {
            print("down")
            try! realm.write {
                for i in (source + 1)...(destination - 1) {
                    let todoA = realm.objects(Todo.self).filter("id == \(todos[i].id)").first!
                    todoA.order = todos[i].order - 1
                }
                let todoB = realm.objects(Todo.self).filter("id == \(moveId)").first!
                todoB.order = destination - 1
            }
            reloadRecords()
        }
        if destination < source {
            print("up")
            try! realm.write {
                
                for i in (destination...(source - 1)).reversed() {
                    let todoA = realm.objects(Todo.self).filter("id == \(todos[i].id)").first!
                    todoA.order = todos[i].order + 1
                }
                let todoB = realm.objects(Todo.self).filter("id == \(moveId)").first!
                todoB.order = destination
            }
            reloadRecords()
        }
    }

}
