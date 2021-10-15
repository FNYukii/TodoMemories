//
//  CustomEditButton.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/15.
//

import SwiftUI

struct CustomEditButton: View {
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }){
            if editMode?.wrappedValue.isEditing == true {
                Text("終了")
            } else {
                Text("並べ替え")
            }
        }
    }
}
