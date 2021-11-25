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
    
    @Binding var id: Int
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    //編集前の値
    @State var oldIsPinned = false
    @State var oldIsAchieved = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Todoを入力", text: $content)
                    .introspectTextField { textField in
                        textField.returnKeyType = .done
                        textField.becomeFirstResponder()
                        if id != 0 {
                            textField.resignFirstResponder()
                        }
                    }
                
                Section {
                    Toggle("Todoを固定", isOn: $isPinned)
                        .disabled(isAchieved)
                    Toggle("達成済み", isOn: $isAchieved)
                        .onChange(of: isAchieved) {value in
                            if value {
                                isPinned = false
                                achievedDate = Date()
                            }
                        }
                    if isAchieved {
                        DatePicker("達成日時", selection: $achievedDate)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }
                
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
            .onAppear(perform: loadTodo)
            
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            Todo.deleteTodo(id: id)
                            editProtocol.loadData()
                            presentation.wrappedValue.dismiss()
                        },
                        .cancel()
                    ]
                )
            }
            
            .navigationBarTitle(navBarTitle, displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentation.wrappedValue.dismiss()
                }){
                    Text("キャンセル")
                        .fontWeight(.regular)
                },
                trailing: Button(action: {
                    if id == 0 {
                        Todo.insertTodo(content: content, isPinned: isPinned, isAchieved: isAchieved, achievedDate: achievedDate)
                    }
                    if id != 0 {
                        Todo.updateTodoContentAndDate(id: id, newContent: content, newAchievedDate: achievedDate)
                        if !oldIsAchieved && isAchieved {
                            Todo.achieveTodo(id: id, achievedDate: achievedDate)
                        } else if oldIsAchieved && !isAchieved {
                            Todo.unachieveTodo(id: id)
                        }
                        if !isAchieved {
                            if !oldIsPinned && isPinned {
                                Todo.pinTodo(id: id)
                            } else if oldIsPinned && !isPinned {
                                Todo.unpinTodo(id: id)
                            }
                        }
                    }
                    editProtocol.loadData()
                    presentation.wrappedValue.dismiss()
                }){
                    Text(navBarDoneText)
                        .fontWeight(.bold)
                }
                    .disabled(content.isEmpty)
            )
        }
        .accentColor(.red)
    }
    
    func loadTodo() {
        if id != 0 {
            let todo = Todo.oneTodo(id: id)
            content = todo.content
            isPinned = todo.isPinned
            isAchieved = todo.isAchieved
            achievedDate = todo.achievedDate
            navBarTitle = "Todoを編集"
            navBarDoneText = "完了"
            oldIsPinned = todo.isPinned
            oldIsAchieved = todo.isAchieved
        }
    }
}
