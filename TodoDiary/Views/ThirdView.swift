//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View {
    @State var currentPageIndex = 0
    var body: some View {
        NavigationView {
            TabView(selection: $currentPageIndex) {
                ForEach(-50..<51) {index in
                    OnePageView(offset: index).tag(index)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .navigationBarTitle("達成グラフ")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
