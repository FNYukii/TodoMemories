//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View {
    
    @State var selectedDate: Date = Date()
    
    @State var isNavLinkActive = false
    
    var body: some View {
        NavigationView {
            
            VStack {
//                CalendarView(selectedDate: $selectedDate)
//                .onChange(of: selectedDate, perform: { value in
//                    isNavLinkActive = true
//                })
                
                LineChart()
                    .frame(height: 400)
                    
                NavigationLink(destination: ResultView(selectedDate: selectedDate), isActive: $isNavLinkActive) {
                    EmptyView()
                }
            }
            
            .navigationBarTitle("完了グラフ")
        }
    }
}
