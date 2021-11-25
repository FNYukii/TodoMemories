//
//  CustomCalendarView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import SwiftUI

struct CustomCalendarView: View {
    
    let showYear: Int
    let showMonth: Int
    @Binding var isNavLinkActive: Bool
    @Binding var selectedDate: Date
    
    @State var days: [Int] = []
    @State var achieveCountsByDay: [Int] = []
    
    init(showYear: Int, showMonth: Int, isNavLinkActive: Binding<Bool>, selectedDate: Binding<Date>) {
        self.showYear = showYear
        self.showMonth = showMonth
        self._isNavLinkActive = isNavLinkActive
        self._selectedDate = selectedDate
        _days = State(initialValue: daysOfMonth(inputYear: showYear, inputMonth: showMonth))
        _achieveCountsByDay = State(initialValue: dailyAchieveCounts())
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                ForEach((0..<weekDays.count), id: \.self) { index in
                    Text("\(weekDays[index])")
                        .font(.subheadline)
                        .frame(alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach((0..<days.count), id: \.self) { index in
                    CalendarDayCell(year: showYear, month: showMonth, day: days[index], isNotEmpty: days[index] != 0, isBold: isToday(showDay: days[index]), isHasAchieved: days[index] != 0 ? achieveCountsByDay[days[index] - 1] != 0 : false, isNavLinkActive: $isNavLinkActive, selectedDate: $selectedDate)
                }
            }
            .onAppear(perform: loadCalendar)
        }
    }
    
    //カレンダーを更新する
    func loadCalendar() {
        achieveCountsByDay = dailyAchieveCounts()
        days = daysOfMonth(inputYear: showYear, inputMonth: showMonth)
    }
    
    //showDaysを取得 例: [0, 0, 0, 1, 2, 3, ...]
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
    
    //achieveCountsを取得 例: [0, 0, 1, 0, 3, 2...]
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
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentDay = calendar.component(.day, from: Date())
        if showDay == currentDay && showYear == currentYear && showMonth == currentMonth {
            return true
        } else {
            return false
        }
    }
}
