//
//  CalendarDayCell.swift
//  TodoDiary
//
//  Created by Yu on 2021/11/25.
//

import SwiftUI

struct CalendarDayCell: View {
    
    let year: Int
    let month: Int
    let day: Int
    
    let isNotEmpty: Bool
    let isBold: Bool
    let isHasAchieved: Bool
    
    @Binding var isNavLinkActive: Bool
    @Binding var selectedDate: Date
    
    var body: some View {
        if isNotEmpty {
            Button(action: {
                if isHasAchieved {
                    jumpToResultView(year: year, month: month, day: day)
                }
            }){
                Text("\(day)")
                    .fontWeight(isBold ? .bold : .regular)
                    .foregroundColor(isHasAchieved ? .accentColor : .secondary)
                    .frame(height: 45, alignment: .top)
            }
        }
        if !isNotEmpty {
            Text("")
                .foregroundColor(.clear)
                .frame(height: 45)
        }
    }
    
    func jumpToResultView(year: Int, month: Int, day: Int) {
        let selectedYmd = year * 10000 + month * 100 + day
        let converter = Converter()
        selectedDate = converter.toDate(inputYmd: selectedYmd)
        isNavLinkActive.toggle()
    }
}