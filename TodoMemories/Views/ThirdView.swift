//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View {
    
    @State var selection = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ForEach(-50..<51) {index in
                    ThirdViewPage(offset: index).tag(index)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .navigationBarTitle("達成グラフ")
        }
    }
    
    func reloadView() {
        //TODO: 0番のページまでもどる
        print("reload ThirdView")
    }
}
