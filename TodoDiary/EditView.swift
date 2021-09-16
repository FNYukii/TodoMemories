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
    
    @State var content = ""
    
    var body: some View {
        NavigationView {
            
            //Todo編集エリア
            Form {
                TextField("Todoを入力", text: $content)
                
                Section {
                    Button(action: {
                        //
                    }){
                        HStack {
                            Text("Todoを固定")
                            Spacer()
                            Image(systemName: "pin")
                        }
                    }
                    Button(action: {
                        //
                    }){
                        HStack {
                            Text("完了済みに変更")
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                    Button(action: {
                        //
                    }){
                        HStack {
                            Text("Todoを削除")
                            Spacer()
                            Image(systemName: "trash")
                        }
                        .foregroundColor(.red)
                        
                    }
                }
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
                    saveDiary()
                    myProtocol.reloadRecords()
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func saveDiary() {
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
    
    
}
