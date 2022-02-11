//
//  CreateView.swift
//  TodoDiary
//
//  Created by Yu on 2022/02/12.
//

import SwiftUI

struct CreateView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    var body: some View {
        NavigationView {
            
            Form {
                
                TextField("Todoを入力", text: $content)
                    .submitLabel(.done)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
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
