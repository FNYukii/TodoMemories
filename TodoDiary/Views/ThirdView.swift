//
//  ThirdView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct ThirdView: View {
    
    let pageCount = 100
    var pages: [AnyView] = []
    @State var currentPage = 0
    
    init() {
        //最初に表示するページの番号を決める
        _currentPage = State(initialValue: pageCount / 2)
        //pageCountの分だけページを用意する
        for index in 0..<pageCount {
            let offset = index - pageCount / 2
            pages.append(AnyView(OnaPageView(offset: offset)))
        }
    }
    
    var body: some View {
        NavigationView {
            PageView(pages, currentPage: $currentPage)
            .navigationBarTitle("達成グラフ")
        }
        
    }
    
}
