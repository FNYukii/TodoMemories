//
//  ResultView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI

struct ResultView: View, EditProtocol {
    
    @Environment(\.presentationMode) var presentation
    
    //ThirdViewのカレンダーで選択された日
    let selectedDate: Date
    
    @State var isShowSheet = false
    @State var selectedTodoId = 0
    @State var isShowActionSheet = false
    
    @State var todosOfTheDay = Todo.noRecord()
    
    @State var isShowTime = UserDefaults.standard.bool(forKey: "isShowTime")
    @State var isAscending = UserDefaults.standard.bool(forKey: "isAscending")
    
    let converter = Converter()
    
    var body: some View {
        
        List {
            Section(header: Text("\(converter.toYmdwText(inputDate: selectedDate))")) {
                ForEach(todosOfTheDay.freeze()) { todo in
                    Button(action: {
                        selectedTodoId = todo.id
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
                    .contextMenu(ContextMenu(menuItems: {
                        ListContextMenuItems(editProtocol: self, todoId: todo.id, isPinned: todo.isPinned, isAchieved: todo.isAchieved, isShowActionSheet: $isShowActionSheet, selectedTodoId: $selectedTodoId)
                    }))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            reloadRecords()
        }
        
        .sheet(isPresented: $isShowSheet) {
            EditView(editProtocol: self)
        }
        
        .actionSheet(isPresented: $isShowActionSheet) {
            ActionSheet(
                title: Text(""),
                message: Text("このTodoを削除してもよろしいですか?"),
                buttons:[
                    .destructive(Text("Todoを削除")) {
                        Todo.deleteTodo(id: selectedTodoId)
                    },
                    .cancel()
                ]
            )
        }
        
        .navigationBarTitle("達成済み")
        .navigationBarItems(
            trailing: Menu {
                Button(action: {
                    isAscending.toggle()
                    UserDefaults.standard.setValue(isAscending, forKey: "isAscending")
                    reloadRecords()
                }){
                    if isAscending {
                        Label("新しい順に並べる", systemImage: "arrow.up")
                    } else {
                        Label("古い順に並べる", systemImage: "arrow.down")
                    }
                }
                Button(action: {
                    isShowTime.toggle()
                    UserDefaults.standard.setValue(isShowTime, forKey: "isShowTime")
                }){
                    if isShowTime {
                        Label("達成時刻を非表示", systemImage: "clock")
                    } else {
                        Label("達成時刻を非表示", systemImage: "clock.fill")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
            }
        )
        
    }
    
    func reloadRecords()  {
        let achievedYmd = converter.toYmd(inputDate: selectedDate)
        todosOfTheDay = Todo.todosOfTheDay(achievedYmd: achievedYmd, isAscending: isAscending)
        if todosOfTheDay.count == 0 {
            presentation.wrappedValue.dismiss()
        }
    }
    
    func getSelectedDiaryId() -> Int {
        return selectedTodoId
    }
    
}
