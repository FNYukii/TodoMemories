//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View, CalendarProtocol {
    
    @State var isNavLinkActive = false
    @State var selectedDate: Date = Date()
    
    @State var showYear = 0
    @State var showMonth = 0
    init() {
        let calendar = Calendar(identifier: .gregorian)
        _showYear = State(initialValue: calendar.component(.year, from: Date()))
        _showMonth = State(initialValue: calendar.component(.month, from: Date()))
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("\(showYear)年 \(showMonth)月")
                    .font(.title3)
                
                LineChart()
                    .frame(height: 250)
                
                CustomCalendarView(calendarProtocol: self, changeFrag: showMonth)
                    
                NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                    EmptyView()
                }
            }
            
            .navigationBarTitle("達成グラフ")
            .navigationBarItems(
                leading: Button("前の月"){
                    prevMonth()
                },
                trailing: Button("次の月"){
                    nextMonth()
                }
            )
        }
    }
    
    //showYearとshowMonthを1つ前にずらす
    func prevMonth() {
        if showMonth == 1 {
            showMonth = 12
            showYear -= 1
        } else {
            showMonth -= 1
        }
    }
    
    //showYearとshowMonthを1つ次にずらす
    func nextMonth() {
        if showMonth == 12 {
            showMonth = 1
            showYear += 1
        } else {
            showMonth += 1
        }
    }
    
    //CustomCalendarViewに表示年を渡す
    func getShowYear() -> Int {
        return showYear
    }
    
    //CustomCalendarViewに表示月を渡す
    func getShowMonth() -> Int {
        return showMonth
    }
    
}
