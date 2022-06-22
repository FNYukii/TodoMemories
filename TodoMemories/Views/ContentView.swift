//
//  ContentView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State private var selection = 0
    
    var handler: Binding<Int> { Binding(
        get: { self.selection },
        set: {
            if $0 == 0 && self.selection == 0 {
                let firstView = FirstView()
                firstView.reloadView()
            }
            if $0 == 1 && self.selection == 1 {
                let secondView = SecondView()
                secondView.reloadView()
            }
            if $0 == 2 && self.selection == 2 {
                let thirdView = ThirdView()
                thirdView.reloadView()
            }
            self.selection = $0
        }
    )}
    
    var body: some View {
        TabView(selection: handler) {
            FirstView()
                .environment(\.realmConfiguration, Todo.customRealmConfig())
                .tabItem {
                    Label("todo", systemImage: "checkmark")
                }
                .tag(0)
            SecondView()
                .tabItem {
                    Label("history", systemImage: "calendar")
                }
                .tag(1)
            ThirdView()
                .tabItem {
                    Label("stats", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
        }
        .accentColor(.red)
    }
}
