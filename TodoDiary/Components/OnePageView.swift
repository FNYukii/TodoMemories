//
//  OnePageView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/21.
//

import SwiftUI

struct OnePageView: View {
    
    var offset: Int
    var showYear: Int
    var showMonth: Int
    
    @State var isNavLinkActive = false
    @State var selectedDate: Date = Date()
    
    init(offset: Int) {
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
            
            LineChart(showYear: showYear, showMonth: showMonth)
                .padding(.horizontal, 5)
                .frame(maxHeight: 250)
            
            CustomCalendarView(showYear: showYear, showMonth: showMonth, isNavLinkActive: $isNavLinkActive, selectedDate: $selectedDate)
                .padding(.horizontal, 5)
            
            Spacer()
            
            NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                EmptyView()
            }
        }
    }
}
