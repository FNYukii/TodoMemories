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
    
    var editProtocol: EditProtocol
    @State var id = 0
    
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    @State var oldIsPinned = false
    @State var oldIsAchieved = false
        
    @State var isShowActionSheet = false
    
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
            .onAppear(perform: loadTodo)
            
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            Todo.deleteTodo(id: id)
                            editProtocol.reloadTodos()
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
    
    func loadTodo() {
        id = editProtocol.todoId()
        let todo = Todo.oneTodoById(id: id)
        content = todo.content
        isPinned = todo.isPinned
        isAchieved = todo.isAchieved
        achievedDate = todo.achievedDate
        oldIsPinned = todo.isPinned
        oldIsAchieved = todo.isAchieved
    }
    
    func saveTodo() {
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
        editProtocol.reloadTodos()
        dismiss()
    }
}
