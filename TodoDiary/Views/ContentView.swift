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
                    Label("Todo", systemImage: "list.bullet")
                }
            SecondView()
                .tabItem {
                    Label("達成済み", systemImage: "checkmark")
                }
            ThirdView()
                .tabItem {
                    Label("達成グラフ", systemImage: "chart.xyaxis.line")
                }
        }
        .accentColor(.red)
    }
}
