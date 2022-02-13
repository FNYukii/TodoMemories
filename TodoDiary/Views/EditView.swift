//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let todo: Todo
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    @State var isShowActionSheet = false
    
    init(todo: Todo) {
        self.todo = todo
        _content = State(initialValue: todo.content)
        _isPinned = State(initialValue: todo.isPinned)
        _isAchieved = State(initialValue: todo.isAchieved)
        _achievedDate = State(initialValue: todo.achievedDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $content)
                    Text("やること")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .opacity(content.isEmpty ? 1 : 0)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                Section {
                    Toggle("Todoを固定", isOn: $isPinned)
                        .disabled(isAchieved)
                    Toggle("達成済み", isOn: $isAchieved)
                        .onChange(of: isAchieved) {value in
                            if value && !todo.isAchieved  {
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
            
            .confirmationDialog("", isPresented: $isShowActionSheet, titleVisibility: .hidden) {
                Button("Todoを削除", role: .destructive) {
                    Todo.deleteTodo(id: todo.id)
                    dismiss()
                }
            } message: {
                Text("このTodoを削除してもよろしいですか?").bold()
            }
            
            .navigationBarTitle("Todoを編集", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Todo.updateTodoContentAndDate(id: todo.id, newContent: content, newAchievedDate: achievedDate)
                        if !todo.isAchieved && isAchieved {
                            Todo.achieveTodo(id: todo.id, achievedDate: achievedDate)
                        } else if todo.isAchieved && !isAchieved {
                            Todo.unachieveTodo(id: todo.id)
                        }
                        if !isAchieved {
                            if !todo.isPinned && isPinned {
                                Todo.pinTodo(id: todo.id)
                            } else if todo.isPinned && !isPinned {
                                Todo.unpinTodo(id: todo.id)
                            }
                        }
                        dismiss()
                    }){
                        Text("完了")
                            .fontWeight(.bold)
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
        .accentColor(.red)
    }
    
}
