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
                                Button(action: {
                                    isShowSheet.toggle()
                                }){
                                    HStack {
                                        Text("\(DayConverter.toHmText(from: todo.achievedDate))")
                                            .foregroundColor(.secondary)
                                        Text("\(todo.content)")
                                            .foregroundColor(.primary)
                                    }
                                }
                                .contextMenu {
                                    TodoContextMenuItems(todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved)
                                }
                                .sheet(isPresented: $isShowSheet) {
                                    EditView(todo: todo)
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                if achievedDaysViewModel.days.count == 0 {
                    Text("達成済みのTodoはありません")
                        .foregroundColor(.secondary)
                }
            }
            
            .navigationBarTitle("達成済み")
        }
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload SecondView")
    }
}
