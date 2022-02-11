//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import Introspect

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let todo: Todo
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    @State var oldIsPinned = false
    @State var oldIsAchieved = false
        
    @State var isShowActionSheet = false
    
    init(todo: Todo) {
        self.todo = todo
        _content = State(initialValue: todo.content)
        _isPinned = State(initialValue: todo.isPinned)
        _isAchieved = State(initialValue: todo.isAchieved)
        _achievedDate = State(initialValue: todo.achievedDate)
        _oldIsPinned = State(initialValue: todo.isPinned)
        _oldIsAchieved = State(initialValue: todo.isAchieved)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Todoを入力", text: $content)
                    .submitLabel(.done)
                
                Section {
                    Toggle("Todoを固定", isOn: $isPinned)
                        .disabled(isAchieved)
                    Toggle("達成済み", isOn: $isAchieved)
                        .onChange(of: isAchieved) {value in
                            if value && !oldIsAchieved {
                                isPinned = false
                                achievedDate = Date()
                            }
                        }
                    if isAchieved {
                        DatePicker("達成日時", selection: $achievedDate)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }
                
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
            
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            Todo.deleteTodo(id: todo.id)
                            dismiss()
                        },
                        .cancel()
                    ]
                )
            }
            
            .navigationBarTitle("Todoを編集", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
                }){
                    Text("キャンセル")
                        .fontWeight(.regular)
                },
                trailing: Button(action: saveTodo){
                    Text("完了")
                        .fontWeight(.bold)
                }
                    .disabled(content.isEmpty)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.red)
    }
    
    func saveTodo() {
        Todo.updateTodoContentAndDate(id: todo.id, newContent: content, newAchievedDate: achievedDate)
        if !oldIsAchieved && isAchieved {
            Todo.achieveTodo(id: todo.id, achievedDate: achievedDate)
        } else if oldIsAchieved && !isAchieved {
            Todo.unachieveTodo(id: todo.id)
        }
        if !isAchieved {
            if !oldIsPinned && isPinned {
                Todo.pinTodo(id: todo.id)
            } else if oldIsPinned && !isPinned {
                Todo.unpinTodo(id: todo.id)
            }
        }
        dismiss()
    }
}
