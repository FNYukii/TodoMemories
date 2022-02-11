//
//  SettingMenu.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/15.
//

import SwiftUI

struct SettingMenu: View {
    
    @Binding var isAscending: Bool
    @Binding var isShowTime: Bool
    
    var body: some View {
        Menu {
            Button(action: {
                isAscending.toggle()
                UserDefaults.standard.setValue(isAscending, forKey: "isAscending")
            }){
                if isAscending {
                    Label("新しい順に並べる", systemImage: "arrow.up")
                } else {
                    Label("古い順に並べる", systemImage: "arrow.down")
                }
            }
            Button(action: {
                isShowTime.toggle()
                UserDefaults.standard.setValue(isShowTime, forKey: "isShowTime")
            }){
                if isShowTime {
                    Label("達成時刻を非表示", systemImage: "clock")
                } else {
                    Label("達成時刻を表示", systemImage: "clock.fill")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}
