//
//  ResultView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI
import RealmSwift

struct ResultView: View, EditProtocol {
    
    //ThirdViewのカレンダーで選択された日
    let selectedDate: Date
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
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
    
    func reloadRecords()  {
        let realm = Todo.customRealm()
        let achievedYmd = converter.toYmd(inputDate: selectedDate)
        todos = realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: isAscending)
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
