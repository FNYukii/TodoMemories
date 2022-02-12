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
                    if isAchieved {
                        DatePicker("達成日時", selection: $achievedDate)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }
            }
            
            .navigationBarTitle("新規Todo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }){
                        Text("キャンセル")
                            .fontWeight(.regular)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Todo.insertTodo(content: content, isPinned: isPinned, isAchieved: isAchieved, achievedDate: achievedDate)
                        dismiss()
                    }){
                        Text("追加")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .accentColor(.red)
    }
}
