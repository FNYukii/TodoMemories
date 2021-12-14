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
    @Binding var id: Int
    
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    @State var oldIsPinned = false
    @State var oldIsAchieved = false
    
    @State var navBarTitle = "新しいTodo"
    @State var navBarDoneText = "追加"
    
    @State var isShowActionSheet = false
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Todoを入力", text: $content)
                    .submitLabel(.done)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                        textField.resignFirstResponder()
                    }
                    .focused($isTextFieldFocused)
                    .onAppear {
                        if id == 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                                isTextFieldFocused = true
                            }
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
                            editProtocol.reloadTodos()
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
                trailing: Button(action: saveTodo){
                    Text(navBarDoneText)
                        .fontWeight(.bold)
                }
                    .disabled(content.isEmpty)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.green)
    }
    
    func loadTodo() {
        if id != 0 {
            let todo = Todo.oneTodoById(id: id)
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
    
    func saveTodo() {
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
        editProtocol.reloadTodos()
        presentation.wrappedValue.dismiss()
    }
}
