//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct SecondView: View {
        
    @ObservedObject private var achievedDaysViewModel = AchievedDaysViewModel()
    @State var isShowSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(achievedDaysViewModel.days) { day in
                        Section(header: Text("\(DayConverter.toStringUpToWeekday(from: day.ymd))")) {
                            ForEach(day.achievedTodos) { todo in
                                TodoRow(todo: todo)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                if achievedDaysViewModel.days.count == 0 {
                    Text("no_todo_achieved_yet")
                        .foregroundColor(.secondary)
                }
            }
            
            .navigationTitle("history")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload SecondView")
    }
}
