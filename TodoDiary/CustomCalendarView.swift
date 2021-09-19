//
//  CustomCalendarView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import SwiftUI

struct CustomCalendarView: View {
    
    var calendarProtocol: CalendarProtocol
    let changeFrag: Int
    
    //カレンダーに表示する年と月
    @State var showYear = 0
    @State var showMonth = 0
    
    //本日の年と月
    @State var currentYear = 0
    @State var currentMonth = 0
    
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var showDays: [Int] = []
    
    var body: some View {
        VStack {
            
            //曜日を表示
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach((0..<weekDays.count), id: \.self) { index in
                    Text("\(weekDays[index])")
                        .font(.subheadline)
                        .frame(alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
            
            //日を表示
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach((0..<showDays.count), id: \.self) { index in
                    if showDays[index] == 0 {
                        Text("")
                            .foregroundColor(.clear)
                    } else if showDays[index] == today() && showYear == currentYear && showMonth == currentMonth {
                        Button("\(showDays[index])"){
                            calendarProtocol.jumpToResultView(year: showYear, month: showMonth, day: showDays[index])
                        }
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    } else {
                        Button("\(showDays[index])"){
                            calendarProtocol.jumpToResultView(year: showYear, month: showMonth, day: showDays[index])
                        }
                        .foregroundColor(.primary)
                    }
                }
                .frame(height: 50, alignment: .center)
                .font(.subheadline)
            }
            .onAppear {
                loadCalendar()
            }
            .onChange(of: changeFrag, perform: { _ in
                loadCalendar()
            })
            
        }
    }
    
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
    
    func loadCalendar() {
        let calenar = Calendar(identifier: .gregorian)
        currentYear = calenar.component(.year, from: Date())
        currentMonth = calenar.component(.month, from: Date())
        showYear = calendarProtocol.getShowYear()
        showMonth = calendarProtocol.getShowMonth()
        showDays = daysOfMonth(inputYear: showYear, inputMonth: showMonth)
    }
    
}
