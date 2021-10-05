//
//  OnePageView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/21.
//

import SwiftUI

struct OnaPageView: View, CalendarProtocol {
    
    //NavigationLink
    @State var isNavLinkActive = false
    @State var selectedDate: Date = Date()
    
    //現在の年月と表示する予定の年月との差分
    var offset = 0
    //表示する年月
    var showYear = 0
    var showMonth = 0
    
    init(offset: Int) {
        //offsetと現在の年月を取得
        self.offset = offset
        let calendar = Calendar(identifier: .gregorian)
        var year = calendar.component(.year, from: Date())
        var month = calendar.component(.month, from: Date())
        //表示する予定の年月までずらす
        if offset > 0 {
            for _ in 0..<offset {
                if month == 12 {
                    month = 1
                    year += 1
                } else {
                    month += 1
                }
            }
        }
        if offset < 0 {
            let plusOffset = 0 - offset
            for _ in 0..<plusOffset {
                if month == 1 {
                    month = 12
                    year -= 1
                } else {
                    month -= 1
                }
            }
        }
        self.showYear = year
        self.showMonth = month
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                            
            Text("\(String(showYear))年 \(showMonth)月")
                .font(.title2)
                .padding(.leading)
            
//            LineChart(showYear: showYear, showMonth: showMonth)
//                .padding(.horizontal, 5)
            
            BarChart()
                .padding(.horizontal, 5)
            
            CustomCalendarView(calendarProtocol: self, changeFrag: showMonth)
                .padding(.horizontal, 5)
            
            NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                EmptyView()
            }
                
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
    
    func jumpToResultView(year: Int, month: Int, day: Int) {
        let selectedYmd = year * 10000 + month * 100 + day
        let converter = Converter()
        selectedDate = converter.toDate(inputYmd: selectedYmd)
        isNavLinkActive.toggle()
    }
    
}
