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
    
    @State var navBarTitle = "Todoを追加"
    @State var isShowAlert = false
    @State var isSaveDisabled = false
    
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
                    .onChange(of: content, perform: { value in
                        textCheck()
                    })
                if isAchieved {
                    Section {
                        DatePicker("完了日時", selection: $achievedDate)
                    }
                }
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
                                    Image(systemName: "pin.slash.fill")
                                    Text("固定を外す")
                                } else {
                                    Image(systemName: "pin.fill")
                                    Text("Todoを固定")
                                }
                            }
                        }
                        .disabled(isSaveDisabled)
                    }
                    //完了切り替えボタン
                    Button(action: {
                        isAchieved.toggle()
                        if isAchieved {
                            isPinned = false
                            achievedDate = Date()
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
                    .disabled(isSaveDisabled)
                    //削除ボタン
                    if id != 0 {
                        Button(action: {
                            isShowAlert.toggle()
                        }){
                            HStack {
                                Image(systemName: "trash")
                                Text("Todoを削除")
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            .onAppear {
                loadTodo()
            }
            
            //削除確認アラート
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text("確認"),
                    message: Text("このTodoを削除してもよろしいですか？"),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .destructive(Text("削除"), action: {
                        deleteRecord()
                        myProtocol.reloadRecords()
                        presentation.wrappedValue.dismiss()
                    })
                )
            }
            
            //ナビゲーションバーの設定
            .navigationBarTitle(navBarTitle, displayMode: .inline)
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
                .disabled(isSaveDisabled)
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
            navBarTitle = "Todoを編集"
        }
        textCheck()
    }
    
    func textCheck() {
        if content.isEmpty {
            isSaveDisabled = true
        } else {
            isSaveDisabled = false
        }
    }
    
    func saveRecord() {
        //レコードを追加する場合
        if id == 0 {
            //新規レコード用のidを生成
            let realm = try! Realm()
            let maxId = realm.objects(Todo.self).sorted(byKeyPath: "id").last?.id ?? 0
            let newId = maxId + 1
            //新規レコード生成
            let todo = Todo()
            todo.id = newId
            todo.content = content
            todo.isPinned = isPinned
            todo.isAchieved = isAchieved
            todo.achievedDate = achievedDate
            todo.achievedYmd = toYmdNumber(inputDate: achievedDate)
            //新規レコード追加
            try! realm.write {
                realm.add(todo)
            }
        }
        //レコードを更新する場合
        if id != 0 {
            let realm = try! Realm()
            let todo = realm.objects(Todo.self).filter("id == \(id)").first!
            try! realm.write {
                todo.content = content
                todo.isPinned = isPinned
                todo.isAchieved = isAchieved
                todo.achievedDate = achievedDate
                todo.achievedYmd = toYmdNumber(inputDate: achievedDate)
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
    
    //Date型変数を年月日の数字に変換する
    func toYmdNumber(inputDate: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: inputDate)
        let month = calendar.component(.month, from: inputDate)
        let day = calendar.component(.day, from: inputDate)
        return year * 10000 + month * 100 + day
    }
    
}
