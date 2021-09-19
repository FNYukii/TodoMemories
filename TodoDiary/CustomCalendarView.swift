//
//  CustomCalendarView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import SwiftUI

struct CustomCalendarView: View {
    
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack {
            
            //年と月を表示
            Text(ymText())
                .font(.title)
            
            //曜日を表示
            HStack {
                Spacer()
                ForEach(0..<weekDays.count){ index in
                    Text(weekDays[index])
                    Spacer()
                }
            }
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach((0...15), id: \.self) {
                    Text("\($0)")
                }
            }
            
        }
    }
    
    //年と月のテキストを生成
    func ymText() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        return "\(year)年 \(month)月"
    }
    
    //うるう年かどうかの判定をする
    func isLeapYear(year:Int) -> Bool {
        return (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0 )) ? true : false
    }
    
    //
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
    
}
