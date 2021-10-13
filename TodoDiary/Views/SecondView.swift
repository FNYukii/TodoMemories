//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift
import WidgetKit

struct SecondView: View, EditProtocol {
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    @State var isShowAlert = false
    
    //Todoを達成した年月日の配列
    @State var achievedYmds: [Int] = []
    init() {
        _achievedYmds = State(initialValue: getAchievedYmds())
    }
    
    //達成時刻を表示するかどうか
    @State var isShowTime = UserDefaults.standard.bool(forKey: "isShowTime")
    //達成日が古い順に並べるかどうか
    @State var isAscending = UserDefaults.standard.bool(forKey: "isAscending")
    
    let converter = Converter()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                List {
                    ForEach(0..<achievedYmds.count) { index in
                        Section(header: Text("\(converter.toYmdwText(inputDate: converter.toDate(inputYmd: achievedYmds[index])))")) {
                            ForEach(getDailyTodos(achievedYmd: achievedYmds[index]).freeze()){ todo in
                                
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
                                        unachieveTodo(id: todo.id)
                                    }) {
                                        Label("未達成に変更", systemImage: "xmark")
                                    }
                                    Button(action: {
                                        selectedTodoId = todo.id
                                        isShowAlert.toggle()
                                    }) {
                                        Label("削除", systemImage: "trash")
                                    }
                                }))
                                
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    reloadRecords()
                }
                
                if achievedYmds.count == 0 {
                    Text("達成済みのTodoはありません")
                        .foregroundColor(.secondary)
                }
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView(editProtocol: self)
            }
            
            .actionSheet(isPresented: $isShowAlert) {
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
            
            .navigationBarTitle("達成済み")
            .navigationBarItems(
                trailing: Menu {
                    Button(action: {
                        isAscending.toggle()
                        UserDefaults.standard.setValue(isAscending, forKey: "isAscending")
                        reloadRecords()
                    }){
                        if isAscending {
                            Label("新しい順に並べる", systemImage: "arrow.up")
                        } else {
                            Label("古い順に並べる", systemImage: "arrow.down")
                        }
                    }
                    Button(action: {
                        isShowTime.toggle()
                        UserDefaults.standard.setValue(isShowTime, forKey: "isShowTime")
                    }){
                        if isShowTime {
                            Label("達成時刻を非表示", systemImage: "clock")
                        } else {
                            Label("達成時刻を表示", systemImage: "clock.fill")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                }
            )
            
        }
    }
    
    //Todo達成年月日の配列を生成する
    func getAchievedYmds() -> [Int] {
        var ymds: [Int] = []
        let achievedTodos = Todo.achievedTodos()
        for achievedTodo in achievedTodos {
            ymds.append(achievedTodo.achievedYmd)
        }
        let orderedSet = NSOrderedSet(array: ymds)
        ymds = orderedSet.array as! [Int]
        if (isAscending) {
            ymds = ymds.reversed()
        }
        return ymds
    }
    
    //特定の年月日に達成したTodoを取得する
    func getDailyTodos(achievedYmd: Int) -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: isAscending)
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
    
    func reloadRecords() {
        achievedYmds = []
        achievedYmds = getAchievedYmds()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
