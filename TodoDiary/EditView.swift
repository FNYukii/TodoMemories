//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct EditView: View {
    
    @Environment(\.presentationMode) var presentation
    var myProtocol: MyProtocol
    
    @State var id = 0
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    var body: some View {
        NavigationView {
            
            //Todo編集エリア
            Form {
                TextField("Todoを入力", text: $content)
                Section {
                    //固定切り替えボタン
                    if !isAchieved {
                        Button(action: {
                            isPinned.toggle()
                            saveRecord()
                            myProtocol.reloadRecords()
                            presentation.wrappedValue.dismiss()
                        }){
                            HStack {
                                if isPinned {
                                    Image(systemName: "pin.slash")
                                    Text("固定を外す")
                                } else {
                                    Image(systemName: "pin.fill")
                                    Text("Todoを固定")
                                }
                            }
                        }
                    }
                    //完了切り替えボタン
                    Button(action: {
                        isAchieved.toggle()
                        if isAchieved {
                            isPinned = false
                        }
                        saveRecord()
                        myProtocol.reloadRecords()
                        presentation.wrappedValue.dismiss()
                    }){
                        HStack {
                            if isAchieved {
                                Image(systemName: "xmark")
                                Text("未完了に戻す")
                            } else {
                                Image(systemName: "checkmark")
                                Text("完了済みに変更")
                            }
                        }
                    }
                    //削除ボタン
                    Button(action: {
                        deleteRecord()
                        myProtocol.reloadRecords()
                        presentation.wrappedValue.dismiss()
                    }){
                        HStack {
                            Image(systemName: "trash")
                            Text("Todoを削除")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                loadTodo()
            }
            
            //ナビゲーションバーの設定
            .navigationBarTitle("Todoを編集", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentation.wrappedValue.dismiss()
                }){
                    Text("キャンセル")
                        .fontWeight(.regular)
                },
                trailing: Button("完了"){
                    saveRecord()
                    myProtocol.reloadRecords()
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func loadTodo() {
        id = myProtocol.getSelectedDiaryId()
        if id != 0 {
            let realm = try! Realm()
            let todo = realm.objects(Todo.self).filter("id == \(id)").first!
            content = todo.content
            isPinned = todo.isPinned
            isAchieved = todo.isAchieved
            achievedDate = todo.achievedDate
        }
    }
    
    func saveRecord() {
        
        if id == 0 {
            //新規レコード用のidを生成
            let realm = try! Realm()
            let maxId = realm.objects(Todo.self).sorted(byKeyPath: "id").last?.id ?? 0
            let newId = maxId + 1
            //新規レコード生成
            let todo = Todo()
            todo.id = newId
            todo.content = content
            //新規レコード追加
            try! realm.write {
                realm.add(todo)
            }
        }
        
        if id != 0 {
            let realm = try! Realm()
            let todo = realm.objects(Todo.self).filter("id == \(id)").first!
            try! realm.write {
                todo.isPinned = isPinned
                todo.isAchieved = isAchieved
                todo.achievedDate = Date()
                todo.content = content
            }
        }
        
    }
    
    func deleteRecord() {
        let realm = try! Realm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    
}
