//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct SecondView: View {
    
    @State var isShowSheet = false
    
    //Todoを達成した年月日の配列
    @State var achievedYmds: [Int] = []
    init() {
        _achievedYmds = State(initialValue: getAchievedYmds())
    }
    
    //達成時刻を表示するかどうか
    @State var isShowTime = UserDefaults.standard.bool(forKey: "isShowTime")
    //達成日が古い順に並べるかどうか
    @State var isAscending = UserDefaults.standard.bool(forKey: "isAscending")
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(0..<achievedYmds.count) { index in
                        Section(header: Text("\(Converter.toYmdwText(inputDate: Converter.toDate(inputYmd: achievedYmds[index])))")) {
                            ForEach(Todo.todosOfTheDay(achievedYmd: achievedYmds[index], isAscending: isAscending).freeze()){ todo in
                                Button(action: {
                                    isShowSheet.toggle()
                                }){
                                    HStack {
                                        if isShowTime {
                                            Text("\(Converter.toHmText(inputDate: todo.achievedDate))")
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
                .onAppear(perform: reloadTodos)
                
                if achievedYmds.count == 0 {
                    Text("達成済みのTodoはありません")
                        .foregroundColor(.secondary)
                }
            }
            
            .navigationBarTitle("達成済み")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SettingMenu(isAscending: $isAscending, isShowTime: $isShowTime)
                }
            }
        }
    }
    
    //Todo達成年月日の配列を生成する
    func getAchievedYmds() -> [Int] {
        var ymds: [Int] = []
        let achievedTodos = Todo.achievedTodos()
        for achievedTodo in achievedTodos {
            ymds.append(achievedTodo.achievedYmd)
        }
        let orderedSet = NSOrderedSet(array: ymds)
        ymds = orderedSet.array as! [Int]
        if (isAscending) {
            ymds = ymds.reversed()
        }
        return ymds
    }
    
    func reloadTodos() {
        achievedYmds = []
        achievedYmds = getAchievedYmds()
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload SecondView")
    }
}
