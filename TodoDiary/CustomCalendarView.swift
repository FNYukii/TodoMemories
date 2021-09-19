//
//  CustomCalendarView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import SwiftUI

struct CustomCalendarView: View {
    
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var showDays: [Int] = [0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
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
                        Text("\(showDays[index])")
                            .frame(height: 50, alignment: .center)
                            .foregroundColor(.clear)
                    } else {
                        Text("\(showDays[index])")
                            .frame(height: 50, alignment: .center)
                    }
                }
            }
            .onAppear {
                showDays = daysOfMonth()
            }
            
        }
    }
    
    //当月の一日の曜日
    func firstWeekday(year:Int,month:Int,day:Int) -> Int{
        var result : Int = 0
        if month == 1 || month ==  2 {
            var changeyear : Int = year
            var changemonth : Int = month
            changeyear -= 1
            changemonth += 12
            result  = (day + (26 * (changemonth + 1))/10 + changeyear + (changeyear / 4) + (5 * (changeyear / 100)) + ((changeyear / 100)/4) + 5) % 7 as Int
        }else{
            result  = (day + (26 * (month + 1))/10 + year + (year / 4) + (5 * (year / 100)) + ((year / 100)/4) + 5) % 7 as Int
        }
        return result
    }
    
    //当月の日の配列 例: [0, 0, 0, 1, 2, 3, ...]
    func daysOfMonth() -> [Int] {
        
        //当日
        let currentDate = Date()
        
        //当月の日数を取得
        let calendar = Calendar(identifier: .gregorian)
        let currentMonth = calendar.component(.month, from: currentDate)
        var components = DateComponents()
        components.year = 2012
        components.month = currentMonth + 1
        components.day = 0
        let date = calendar.date(from: components)!
        let dayCount = calendar.component(.day, from: date)
        
        //当月一日の曜日を取得 Sat: 1, Sun: 2, Mon: 3... Fri: 7
        let lastMonthDate = calendar.date(byAdding: .month,value: -1, to: currentDate)!
        let firstDate = calendar.date(bySetting: .day, value: 2, of: lastMonthDate)!
        let firstWeekday = calendar.component(.weekday, from: firstDate)

        //当月の全ての日の配列を生成
        var days: [Int] = []
        
        //当月一日の曜日を元に、当月開始日まで0で埋めていく
        switch firstWeekday {
        case 3:
            days.append(0)
        case 4:
            days += [0, 0]
        case 5:
            days += [0, 0, 0]
        case 6:
            days += [0, 0, 0, 0]
        case 7:
            days += [0, 0, 0, 0, 0]
        case 1:
            days += [0, 0, 0, 0, 0, 0]
        default:
            break
        }
        
        //残りの日を当月日数分埋めていく
        for index in (1...dayCount) {
            days.append(index)
        }
        
        return days
    }
    
}
