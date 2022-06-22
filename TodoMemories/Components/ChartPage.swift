//
//  ChartPage.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import SwiftUI

struct ChartPage: View {
    
    let pageOffset: Int
    
    @State private var countsOfTodoAchieved: [Int] = []
    @State private var pageTitle = ""
        
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(pageTitle)
                .font(.title)
            HStack {
                Text("achievedTodos")
                Text("\(countsOfTodoAchieved.reduce(0) { $0 + $1 })")
            }
            .foregroundColor(.secondary)
            BarChart(countsOfTodoAchieved: countsOfTodoAchieved)
                .padding(.bottom)
        }
        .frame(height: 300)
        .onAppear(perform: loadCountsOfTodoAchieved)
    }
    
    func loadCountsOfTodoAchieved() {
        let shiftedNow = DayConverter.nowShiftedByMonth(offset: pageOffset)
        self.pageTitle = DayConverter.toStringUpToMonth(from: shiftedNow)
        self.countsOfTodoAchieved = Todo.countsOfTodoInMonth(year: shiftedNow.year!, month: shiftedNow.month!)
    }
}
