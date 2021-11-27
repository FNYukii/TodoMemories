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
            print("tab\($0) selected")
            if $0 == self.selection {
                print("reload view")
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
        .accentColor(.red)
    }
}
