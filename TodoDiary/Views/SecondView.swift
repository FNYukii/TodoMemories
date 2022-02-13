//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct SecondView: View {
        
    @ObservedObject var ymdViewModel = YmdViewModel()
    
    @State var isShowTime = UserDefaults.standard.bool(forKey: "isShowTime")
    @State var isAscending = UserDefaults.standard.bool(forKey: "isAscending")
    @State var isShowSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(0..<ymdViewModel.achievedYmds.count) { index in
                        Section(header: Text("\(Converter.toYmdwText(from: Converter.toDate(from: ymdViewModel.achievedYmds[index])))")) {
                            ForEach(Todo.todosOfTheDay(achievedYmd: ymdViewModel.achievedYmds[index], isAscending: isAscending).freeze()){ todo in
                                Button(action: {
                                    isShowSheet.toggle()
                                }){
                                    HStack {
                                        if isShowTime {
                                            Text("\(Converter.toHmText(from: todo.achievedDate))")
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
                }
                .listStyle(InsetGroupedListStyle())
                
                if ymdViewModel.achievedYmds.count == 0 {
                    Text("達成済みのTodoはありません")
                        .foregroundColor(.secondary)
                }
            }
            
            .onChange(of: isAscending){value in
                ymdViewModel.loadAchievedYmds()
            }
            
            .navigationBarTitle("達成済み")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SettingMenu(isAscending: $isAscending, isShowTime: $isShowTime)
                }
            }
        }
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload SecondView")
    }
}
