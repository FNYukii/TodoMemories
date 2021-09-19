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
            
        }
    }
    
    func ymText() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        return "\(year)年 \(month)月"
    }
    
}
