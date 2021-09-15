//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State var content = ""
    
    var body: some View {
        NavigationView {
            
            //Todo編集エリア
            Form {
                TextField("Todoを入力", text: $content)
                
                Section {
                    Button("Todoを固定"){
                        //Todoを固定
                    }
                    Button(action: {
                        //Todoを削除
                    }){
                        Text("Todoを削除")
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
                    //Save Todo
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
}
