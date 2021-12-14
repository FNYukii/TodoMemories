//
//  ContentView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

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
                .tabItem {
                    Label("Todo", systemImage: "list.bullet")
                }
                .tag(0)
            SecondView()
                .tabItem {
                    Label("達成済み", systemImage: "checkmark")
                }
                .tag(1)
            ThirdView()
                .tabItem {
                    Label("達成グラフ", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
        }
        .accentColor(.green)
    }
}
