//
//  ContentView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Todo")
                }
            SecondView()
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("達成済み")
                }
            ThirdView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("達成グラフ")
                }
            FourthView()
                .tabItem {
                    Image(systemName: "pin")
                    Text("テスト")
                }
        }
    }
}