//
//  EditView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            Text("Hello")
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
