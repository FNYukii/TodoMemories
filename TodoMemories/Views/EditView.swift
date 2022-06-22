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
                    Text("todo")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .opacity(content.isEmpty ? 1 : 0)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                Section {
                    Toggle("pin", isOn: $isPinned)
                        .disabled(isAchieved)
                    Toggle("make_achieved", isOn: $isAchieved)
                        .onChange(of: isAchieved) {value in
                            if value && !todo.isAchieved  {
                                isPinned = false
                                achievedDate = Date()
                            }
                        }
                    if isAchieved {
                        DatePicker("achieved_at", selection: $achievedDate)
                    }
                }
                
                Section {
                    Button(action: {
                        isShowActionSheet.toggle()
                    }){
                        Text("delete_todo")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            
            .confirmationDialog("", isPresented: $isShowActionSheet, titleVisibility: .hidden) {
                Button("delete_todo", role: .destructive) {
                    Todo.deleteTodo(id: todo.id)
                    dismiss()
                }
            } message: {
                Text("are_you_sure_you_want_to_delete_this_todo").bold()
            }
            
            .navigationBarTitle("edit_todo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
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
                        Text("done")
                            .fontWeight(.bold)
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.red)
    }
    
}
