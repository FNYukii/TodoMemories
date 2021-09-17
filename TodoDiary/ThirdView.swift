//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View {
    
    @State var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            
            CalendarView(selectedDate: $selectedDate)
                                
            .navigationBarTitle("カレンダー")
        }
    }
}
