//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift
import WidgetKit
import Introspect

struct EditView: View {
    
    @Environment(\.presentationMode) var presentation
    var editProtocol: EditProtocol
    
    @State var navBarTitle = "新しいTodo"
    @State var navBarDoneText = "追加"
    @State var isShowActionSheet = false
    @State var isStartEditing = true
    
    @State var id = 0
    @State var content = ""
    @State var isPinned = false
    @State var isAchieved = false
    @State var achievedDate = Date()
    
    var body: some View {
        NavigationView {
            
            Form {
                //Todo内容入力エリア
                TextField("Todoを入力", text: $content)
                    .introspectTextField { textField in
                        textField.returnKeyType = .done
                        if isStartEditing && id == 0 {
                            textField.becomeFirstResponder()
                            isStartEditing = false
                        }
                    }
                Section {
                    //固定切り替えスイッチ
                    Toggle("Todoを固定", isOn: $isPinned)
                        .disabled(isAchieved)
                    //達成切り替えスイッチ
                    Toggle("達成済み", isOn: $isAchieved)
                        .onChange(of: isAchieved) {value in
                            if value {
                                isPinned = false
                                achievedDate = Date()
                            }
                        }
                    //達成日時
                    if isAchieved {
                        DatePicker("達成日時", selection: $achievedDate)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }
                //削除ボタン
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
            .onAppear {
                loadTodo()
            }
            
            //削除確認アクションシート
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(
                    title: Text(""),
                    message: Text("このTodoを削除してもよろしいですか?"),
                    buttons:[
                        .destructive(Text("Todoを削除")) {
                            deleteRecord()
                            WidgetCenter.shared.reloadAllTimelines()
                            editProtocol.reloadRecords()
                            presentation.wrappedValue.dismiss()
                        },
                        .cancel()
                    ]
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
                trailing: Button(navBarDoneText){
                    saveRecord()
                    WidgetCenter.shared.reloadAllTimelines()
                    editProtocol.reloadRecords()
                    presentation.wrappedValue.dismiss()
                }
                    .disabled(content.isEmpty)
            )
        }
        .accentColor(.red)
    }
    
    func loadTodo() {
        id = editProtocol.getSelectedDiaryId()
        if id != 0 {
            let realm = Todo.customRealm()
            let todo = realm.objects(Todo.self).filter("id == \(id)").first!
            content = todo.content
            isPinned = todo.isPinned
            isAchieved = todo.isAchieved
            achievedDate = todo.achievedDate
            navBarTitle = "Todoを編集"
            navBarDoneText = "完了"
        }
    }
    
    func saveRecord() {
        //レコードを追加する場合
        if id == 0 {
            //新規レコード用のidを生成
            let realm = Todo.customRealm()
            let maxId = realm.objects(Todo.self).sorted(byKeyPath: "id").last?.id ?? 0
            let newId = maxId + 1
            
            //新規レコード用のorderを生成
            let maxOrder = Todo.all().sorted(byKeyPath: "order").last?.order ?? 0
            let newOrder = maxOrder + 1
            
            //新規レコード生成
            let todo = Todo()
            todo.id = newId
            todo.order = newOrder
            todo.content = content
            todo.isPinned = isPinned
            todo.isAchieved = isAchieved
            todo.achievedDate = achievedDate
            let converter = Converter()
            todo.achievedYmd = converter.toYmd(inputDate: achievedDate)
            //新規レコード追加
            try! realm.write {
                realm.add(todo)
            }
        }
        //レコードを更新する場合
        if id != 0 {
            let realm = Todo.customRealm()
            let todo = realm.objects(Todo.self).filter("id == \(id)").first!
            try! realm.write {
                todo.content = content
                todo.isPinned = isPinned
                todo.isAchieved = isAchieved
                todo.achievedDate = achievedDate
                let converter = Converter()
                todo.achievedYmd = converter.toYmd(inputDate: achievedDate)
            }
        }
    }
    
    func deleteRecord() {
        let realm = Todo.customRealm()
        let todo = realm.objects(Todo.self).filter("id == \(id)").first!
        try! realm.write {
            realm.delete(todo)
        }
    }
    
}
