//
//  ResultView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI

struct ResultView: View {
    
    @Environment(\.dismiss) var dismiss
    
    //ThirdViewのカレンダーで選択された日
    let selectedDate: Date
    
    @State var isShowSheet = false
    
    @State var todosOfTheDay = Todo.noRecord()
    
    @State var isShowTime = UserDefaults.standard.bool(forKey: "isShowTime")
    @State var isAscending = UserDefaults.standard.bool(forKey: "isAscending")
    
    let converter = Converter()
    
    var body: some View {
        List {
            Section(header: Text("\(converter.toYmdwText(inputDate: selectedDate))")) {
                ForEach(todosOfTheDay.freeze()) { todo in
                    Button(action: {
                        isShowSheet.toggle()
                    }){
                        HStack {
                            if isShowTime {
                                Text("\(converter.toHmText(inputDate: todo.achievedDate))")
                                    .foregroundColor(.secondary)
                            }
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
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: reloadTodos)
        
        .navigationBarTitle("達成済み")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SettingMenu(isAscending: $isAscending, isShowTime: $isShowTime)
            }
        }
    }
    
    func reloadTodos()  {
        let achievedYmd = converter.toYmd(inputDate: selectedDate)
        todosOfTheDay = Todo.todosOfTheDay(achievedYmd: achievedYmd, isAscending: isAscending)
        if todosOfTheDay.count == 0 {
            dismiss()
        }
    }
}
