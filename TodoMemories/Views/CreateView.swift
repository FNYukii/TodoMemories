//
//  CreateView.swift
//  TodoDiary
//
//  Created by Yu on 2022/02/12.
//

import SwiftUI
import Introspect

struct CreateView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    var body: some View {
        NavigationView {
            
            Form {
                                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $content)
                        .introspectTextView { textEditor in
                            textEditor.becomeFirstResponder()
                        }
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
                    if isAchieved {
                        DatePicker("achieved_at", selection: $achievedDate)
                    }
                }
            }
            
            .navigationBarTitle("new_todo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }){
                        Text("cancel")
                            .fontWeight(.regular)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Todo.insertTodo(content: content, isPinned: isPinned, isAchieved: isAchieved, achievedDate: achievedDate)
                        dismiss()
                    }){
                        Text("add")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .accentColor(.red)
    }
}
