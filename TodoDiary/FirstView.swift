//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct FirstView: View {
    
    @State var isShowSheet = false
    
    var body: some View {
        NavigationView {
            
            Form {
                
                Section(header: Text("固定済み")) {
                    Text("ご飯食べる")
                    Text("バグ直す")
                }
                
                Section(header: Text("その他")) {
                    Text("買い物する")
                    Text("7Days to Die")
                    Text("ステーキ食べに行く")
                }
                
                
            }
            
            .sheet(isPresented: $isShowSheet) {
                EditView()
            }
            
            .navigationBarTitle("Todo")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowSheet.toggle()
                }){
                    Image(systemName: "plus.circle.fill")
                    Text("新しいTodo")
                }
            
            )
            
        }
    }
}
