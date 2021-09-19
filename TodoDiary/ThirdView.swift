//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View {
    
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
                
                Text("\(showYear)年 \(showMonth)日")
                    .font(.title3)
                
                LineChart()
                    .frame(height: 250)
                
                CustomCalendarView(showYear: showYear, showMonth: showMonth)
                    
                NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                    EmptyView()
                }
            }
            
            .navigationBarTitle("達成グラフ")
            .navigationBarItems(
                leading: Button("前の月"){
                    //
                },
                trailing: Button("次の月"){
                    //
                }
            )
        }
    }
        
}
