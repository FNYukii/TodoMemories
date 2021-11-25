//
//  CustomCalendarView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import SwiftUI

struct CustomCalendarView: View {
        
    //NavLink
    @Binding var isNavLinkActive: Bool
    @Binding var selectedDate: Date
    
    //カレンダーに表示する年と月
    let showYear: Int
    let showMonth: Int
    
    //カレンダーの日付の高さ
    let lineHeight: CGFloat = 45
    
    //日別Todo完了数と日付
    @State var achieveCounts: [Int] = []
    @State var showDays: [Int] = []

    //曜日
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack {
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach((0..<weekDays.count), id: \.self) { index in
                    Text("\(weekDays[index])")
                        .font(.subheadline)
                        .frame(alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach((0..<showDays.count), id: \.self) { index in
                    
                    if showDays[index] == 0 {
                        Text("")
                            .foregroundColor(.clear)
                            .frame(height: lineHeight)
                    }
                    
                    if showDays[index] != 0 {
                        VStack {
                            
                            //表示する日付が今日
                            if isToday(showDay: showDays[index]) {
                                //Todo達成済み
                                if achieveCounts[showDays[index] - 1] != 0 {
                                    Button(action: {
                                        jumpToResultView(year: showYear, month: showMonth, day: showDays[index])
                                    }){
                                        Text("\(showDays[index])")
                                            .fontWeight(.bold)
                                    }
                                }
                                //Todo未達成
                                else {
                                    Text("\(showDays[index])")
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                }
                            }
                            //表示する日付が今日でない
                            else {
                                //Todo達成済み
                                if achieveCounts[showDays[index] - 1] != 0 {
                                    Button("\(showDays[index])") {
                                        jumpToResultView(year: showYear, month: showMonth, day: showDays[index])
                                    }
                                }
                                //Todo未達成
                                else {
                                    Text("\(showDays[index])")
                                    .foregroundColor(.secondary)
                                }
                            }
                        }
                        .font(.subheadline)
                        .frame(height: lineHeight, alignment: .top)
                    }
                }
            }
            .onAppear {
                loadCalendar()
            }
        }
    }
    
    //今日の日をInt型で返す
    func today() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.day, from: Date())
    }
    
    //表示月の日の配列 例: [0, 0, 0, 1, 2, 3, ...]
    func daysOfMonth(inputYear: Int, inputMonth: Int) -> [Int] {
        
        //表示月の日数を取得
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = inputYear
        components.month = inputMonth + 1
        components.day = 0
        let date = calendar.date(from: components)!
        let dayCount = calendar.component(.day, from: date)
        
        //表示月一日の曜日を取得 Sat: 1, Sun: 2, Mon: 3... Fri: 7
        let firstDate = calendar.date(from: DateComponents(year: inputYear, month: inputMonth, day: 1, hour: 21, minute: 0, second: 0))!
        let firstWeekday = calendar.component(.weekday, from: firstDate)

        //表示月の全ての日の配列を生成
        var days: [Int] = []
        
        //表示月一日の曜日を元に、当月開始日まで0で埋めていく
        switch firstWeekday {
        case 2:
            days.append(0)
        case 3:
            days += [0, 0]
        case 4:
            days += [0, 0, 0]
        case 5:
            days += [0, 0, 0, 0]
        case 6:
            days += [0, 0, 0, 0, 0]
        case 7:
            days += [0, 0, 0, 0, 0, 0]
        default:
            break
        }
        
        //残りの日を表示月日数分埋めていく
        for index in (1...dayCount) {
            days.append(index)
        }
        
        return days
    }
    
    //カレンダーを更新する
    func loadCalendar() {
        showDays = daysOfMonth(inputYear: showYear, inputMonth: showMonth)
        achieveCounts = dailyAchieveCounts()
    }
    
    //日別Todo達成数の配列 例: [0, 0, 1, 0, 3, 2...]
    func dailyAchieveCounts() -> [Int] {
        //当月の日数を取得
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2012
        components.month = showMonth + 1
        components.day = 0
        let date = calendar.date(from: components)!
        let dayCount = calendar.component(.day, from: date)
        
        //当月のTodo日別達成数の配列を生成
        var achieveCounts: [Int] = []
        for day in (1...dayCount) {
            let achievedYmd = showYear * 10000 + showMonth * 100 + day
            let todos = Todo.todosOfTheDay(achievedYmd: achievedYmd, isAscending: true)
            achieveCounts.append(todos.count)
        }
        
        return achieveCounts
    }
    
    //その日が今日かどうか確認
    func isToday(showDay: Int) -> Bool {
        let calenar = Calendar(identifier: .gregorian)
        let currentYear = calenar.component(.year, from: Date())
        let currentMonth = calenar.component(.month, from: Date())
        if showDay == today() && showYear == currentYear && showMonth == currentMonth {
            return true
        } else {
            return false
        }
    }
    
    //ResultViewへ遷移する
    func jumpToResultView(year: Int, month: Int, day: Int) {
        let selectedYmd = year * 10000 + month * 100 + day
        let converter = Converter()
        selectedDate = converter.toDate(inputYmd: selectedYmd)
        isNavLinkActive.toggle()
    }
}
