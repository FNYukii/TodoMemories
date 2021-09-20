//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View, CalendarProtocol {
    
    //NavigationLink
    @State var isNavLinkActive = false
    @State var selectedDate: Date = Date()
    
    //チャートとカレンダーが表示する年月
    @State var showYear = 0
    @State var showMonth = 0
    init() {
        let calendar = Calendar(identifier: .gregorian)
        _showYear = State(initialValue: calendar.component(.year, from: Date()))
        _showMonth = State(initialValue: calendar.component(.month, from: Date()))
    }
    
    //スワイプ座標
    @State private var labelPosX:CGFloat = 0

    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("\(showYear)年 \(showMonth)月")
                    .font(.title3)
                
                LineChart(showYear: showYear, showMonth: showMonth)
                
                CustomCalendarView(calendarProtocol: self, changeFrag: showMonth)
                    
                NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                    EmptyView()
                }
            }
            .gesture(DragGesture()
                .onEnded({ value in
                    if (abs(value.translation.width) < 10) { return }
                    if (value.translation.width < 0 ) {
                        nextMonth()
                    } else if (value.translation.width > 0 ) {
                        prevMonth()
                    }
                })
            )
            
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
    
    //Int型のymdをDate型に変換する
    func toDate(inputYmd: Int) -> Date {
        let year = inputYmd / 10000
        let month = (inputYmd % 10000) / 100
        let day = (inputYmd % 100)
        let dateComponent = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
        return dateComponent.date!
    }
    
    //CustomCalendarViewに表示年を渡す
    func getShowYear() -> Int {
        return showYear
    }
    
    //CustomCalendarViewに表示月を渡す
    func getShowMonth() -> Int {
        return showMonth
    }
    
    func jumpToResultView(year: Int, month: Int, day: Int) {
        let selectedYmd = year * 10000 + month * 100 + day
        selectedDate = toDate(inputYmd: selectedYmd)
        isNavLinkActive.toggle()
    }
    
}
