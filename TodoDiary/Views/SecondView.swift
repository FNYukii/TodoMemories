//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct SecondView: View, EditProtocol {
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    
    //Todoを達成した年月日の配列
    @State var achievedYmds: [Int] = []
    init() {
        _achievedYmds = State(initialValue: getAchievedYmds())
    }
    
    //達成時刻を表示するかどうか
    @State var isShowAchievedTime = false
    //達成日が古い順に並べるかどうか
    @State var isSortAscending = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Form {
                    ForEach(0..<achievedYmds.count) { index in
                        Section(header: Text("\(toYmdwText(inputDate: toDate(inputYmd: achievedYmds[index])))")) {
                            ForEach(getDailyTodos(achievedYmd: achievedYmds[index]).freeze()){ todo in
                                
                                Button(action: {
                                    selectedTodoId = todo.id
                                    isShowSheet.toggle()
                                }){
                                    HStack {
                                        if isShowAchievedTime {
                                            Text("\(toHmText(inputDate: todo.achievedDate))")
                                                .foregroundColor(.secondary)
                                        }
                                        Text("\(todo.content)")
                                            .foregroundColor(.primary)
                                    }
                                }
                                
                            }
                        }
                    }
                }
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
            
            .navigationBarTitle("達成済み")
            .navigationBarItems(
                leading: Button(action: {
                    isSortAscending.toggle()
                    reloadRecords()
                }){
                    if isSortAscending {
                        Text("新しい順に並べる")
                    } else {
                        Text("古い順に並べる")
                    }
                },
                trailing: Button(action: {
                    isShowAchievedTime.toggle()
                }){
                    if isShowAchievedTime {
                        Text("達成時刻を非表示")
                    } else {
                        Text("達成時刻を表示")
                    }
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
        if (isSortAscending) {
            ymds = ymds.reversed()
        }
        return ymds
    }
    
    //特定の年月日に達成したTodoを取得する
    func getDailyTodos(achievedYmd: Int) -> Results<Todo> {
        let realm = Todo.customRealm()
        return realm.objects(Todo.self).filter("isAchieved == true && achievedYmd == \(achievedYmd)").sorted(byKeyPath: "achievedDate", ascending: isSortAscending)
    }
    
    //Int型の年月日をDate型に変換する
    func toDate(inputYmd: Int) -> Date {
        let year = inputYmd / 10000
        let month = (inputYmd % 10000) / 100
        let day = (inputYmd % 100)
        let dateComponent = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
        return dateComponent.date!
    }
    
    //Date型変数を年月日と曜日のテキストに変換する
    func toYmdwText(inputDate: Date) -> String {
        //年月日のテキストを生成
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年 M月 d日"
        let ymdText = dateFormatter.string(from: inputDate)
        //曜日のテキストを生成
        let calendar = Calendar(identifier: .gregorian)
        let weekdayNumber = calendar.component(.weekday, from: inputDate)
        let weekdaySymbolIndex: Int = weekdayNumber - 1
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja") as Locale
        let weekDayText = formatter.shortWeekdaySymbols[weekdaySymbolIndex]
        //２つのテキストを文字列連結する
        return ymdText + " " + weekDayText
    }
    
    //Date型変数を時刻のテキストに変換する
    func toHmText(inputDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: inputDate)
        let minute = calendar.component(.minute, from: inputDate)
        let hourStr = String(NSString(format: "%02d", hour))
        let minuteStr = String(NSString(format: "%02d", minute))
        return hourStr + ":" + minuteStr
    }
    
    func reloadRecords() {
        achievedYmds = []
        achievedYmds = getAchievedYmds()
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
