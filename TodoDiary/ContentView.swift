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
                    Image(systemName: "magnifyingglass")
                    Text("検索")
                }
            ThirdView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }
        }
    }
}
