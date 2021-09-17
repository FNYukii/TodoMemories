//
//  ResultView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI
import RealmSwift

struct ResultView: View, MyProtocol {
    
    let selectedDate: Date
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
    @State var todos = Todo.noRecord()
    
    var body: some View {
        
        Form {
            ForEach(todos.freeze()) { todo in
                Button("\(todo.content)"){
                    selectedTodoId = todo.id
                    isShowSheet.toggle()
                }
                .foregroundColor(.primary)
            }
        }
        .onAppear {
            loadTodos()
        }
        
        .sheet(isPresented: $isShowSheet) {
            EditView(myProtocol: self)
        }
        
        .navigationBarTitle("\(toYmdText(inputDate: selectedDate)) \(toWeekdayText(inputDate: selectedDate))")
    }
    
    func reloadRecords()  {
        loadTodos()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
    //検索結果のTodosを取得
    func loadTodos() {
        let realm = try! Realm()
        let achievedYmd = toYmdNumber(inputDate: selectedDate)
        todos = realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: false)
    }
    
    //Date型変数を年月日の数字に変換する
    func toYmdNumber(inputDate: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: inputDate)
        let month = calendar.component(.month, from: inputDate)
        let day = calendar.component(.day, from: inputDate)
        return year * 10000 + month * 100 + day
    }
    
    //Date型変数を年月日のみの文字列に変換する
    func toYmdText(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年 M月 d日"
        return dateFormatter.string(from: inputDate)
    }
    
    //Date型変数を曜日のみの文字列に変換する
    func toWeekdayText(inputDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let weekdayNumber = calendar.component(.weekday, from: inputDate)
        let weekdaySymbolIndex: Int = weekdayNumber - 1
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja") as Locale
        return formatter.shortWeekdaySymbols[weekdaySymbolIndex]
    }
    
}
