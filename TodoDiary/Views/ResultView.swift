//
//  ResultView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI
import RealmSwift
import WidgetKit

struct ResultView: View, EditProtocol {
    
    //ThirdViewのカレンダーで選択された日
    let selectedDate: Date
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    @State var isShowAlert = false
    
    @State var todos = Todo.noRecord()
    
    @State var isShowTime = UserDefaults.standard.bool(forKey: "isShowTime")
    @State var isAscending = UserDefaults.standard.bool(forKey: "isAscending")
    
    let converter = Converter()
    
    var body: some View {
        
        ZStack {
            
            Form {
                ForEach(todos.freeze()) { todo in
                    Button(action: {
                        selectedTodoId = todo.id
                        isShowSheet.toggle()
                    }){
                        HStack {
                            if isShowTime {
                                Text("\(converter.toHmText(inputDate: todo.achievedDate))")
                                    .foregroundColor(.secondary)
                            }
                            Text("\(todo.content)")
                                .foregroundColor(.primary)
                        }
                    }
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: {
                            editTodo(id: todo.id)
                        }) {
                            Text("編集")
                            Image(systemName: "pencil")
                        }
                        Button(action: {
                            unachieveTodo(id: todo.id)
                        }) {
                            Text("未達成に変更")
                            Image(systemName: "xmark")
                        }
                        Button(action: {
                            selectedTodoId = todo.id
                            isShowAlert.toggle()
                        }) {
                            Text("削除")
                            Image(systemName: "trash")
                        }
                    }))
                }
            }
            .onAppear {
                reloadRecords()
            }
            
            if todos.count == 0 {
                Text("この日に達成したTodoはありません")
                    .foregroundColor(.secondary)
            }
            
        }
        
        .sheet(isPresented: $isShowSheet) {
            EditView(editProtocol: self)
        }
        
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("確認"),
                message: Text("このTodoを削除してもよろしいですか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除"), action: {
                    deleteTodo()
                })
            )
        }
        
        .navigationBarTitle("\(converter.toYmdwText(inputDate: selectedDate))")
        .navigationBarItems(
            trailing: Menu {
                Button(action: {
                    isAscending.toggle()
                    UserDefaults.standard.setValue(isAscending, forKey: "isAscending")
                    reloadRecords()
                }){
                    if isAscending {
                        Image(systemName: "arrow.up")
                        Text("新しい順に並べる")
                    } else {
                        Image(systemName: "arrow.down")
                        Text("古い順に並べる")
                    }
                }
                Button(action: {
                    isShowTime.toggle()
                    UserDefaults.standard.setValue(isShowTime, forKey: "isShowTime")
                }){
                    if isShowTime {
                        Image(systemName: "clock")
                        Text("達成時刻を非表示")
                    } else {
                        Image(systemName: "clock.fill")
                        Text("達成時刻を表示")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
            }
        )
        
    }
    
    func editTodo(id: Int) {
        selectedTodoId = id
        isShowSheet.toggle()
    }
    
    func unachieveTodo(id: Int) {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            todo.isAchieved = false
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
    
    func reloadRecords()  {
        let realm = Todo.customRealm()
        let achievedYmd = converter.toYmd(inputDate: selectedDate)
        todos = realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: isAscending)
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
