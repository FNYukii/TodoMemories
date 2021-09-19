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
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text(ymText())
                    .font(.title3)
                
                LineChart()
                    .frame(height: 250)
                
                CustomCalendarView()
                    
                NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                    EmptyView()
                }
            }
            
            .navigationBarTitle("達成グラフ")
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
    
}
