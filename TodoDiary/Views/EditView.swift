//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import Introspect

struct EditView: View {
    
    @Environment(\.presentationMode) var presentation
    var editProtocol: EditProtocol
    
    @State var navBarTitle = "新しいTodo"
    @State var navBarDoneText = "追加"
    @State var isShowActionSheet = false
    @State var isStartEditing = true
    
    @State var id = 0
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    var body: some View {
        NavigationView {
            
            Form {
                //Todo内容入力エリア
                TextField("Todoを入力", text: $content)
                    .introspectTextField { textField in
                        textField.returnKeyType = .done
                        if isStartEditing && id == 0 {
                            textField.becomeFirstResponder()
                            isStartEditing = false
                        }
                    }
                Section {
                    //固定切り替えスイッチ
                    Toggle("Todoを固定", isOn: $isPinned)
                        .disabled(isAchieved)
                    //達成切り替えスイッチ
                    Toggle("達成済み", isOn: $isAchieved)
                        .onChange(of: isAchieved) {value in
                            if value {
                                isPinned = false
                                achievedDate = Date()
                            }
                        }
                    //達成日時
                    if isAchieved {
                        DatePicker("達成日時", selection: $achievedDate)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }
                //削除ボタン
                if id != 0 {
                    Section {
                        Button(action: {
                            isShowActionSheet.toggle()
                        }){
                            Text("Todoを削除")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .onAppear {
                loadTodo()
            }
            
            //削除確認アクションシート
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            Todo.deleteTodo(id: id)
                            editProtocol.reloadRecords()
                            presentation.wrappedValue.dismiss()
                        },
                        .cancel()
                    ]
                )
            }
            
            //ナビゲーションバーの設定
            .navigationBarTitle(navBarTitle, displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentation.wrappedValue.dismiss()
                }){
                    Text("キャンセル")
                        .fontWeight(.regular)
                },
                trailing: Button(navBarDoneText){
                    if id == 0 {
                        Todo.insertTodo(content: content, isPinned: isPinned, isAchieved: isAchieved, achievedDate: achievedDate)
                    } else {
                        Todo.updateTodo(id: id, content: content, isPinned: isPinned, isAchieved: isAchieved, achievedDate: achievedDate)
                    }
                    editProtocol.reloadRecords()
                    presentation.wrappedValue.dismiss()
                }
                    .disabled(content.isEmpty)
            )
        }
        .accentColor(.red)
    }
    
    func loadTodo() {
        id = editProtocol.getSelectedDiaryId()
        if id != 0 {
            let todo = Todo.oneTodo(id: id)
            content = todo.content
            isPinned = todo.isPinned
            isAchieved = todo.isAchieved
            achievedDate = todo.achievedDate
            navBarTitle = "Todoを編集"
            navBarDoneText = "完了"
        }
    }
    
}
