//
//  ChartsSection.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import SwiftUI

struct ChartsSection: View {
    
    @State private var pageSelection = 0
    
//    init() {
//        UITableView.appearance().rowHeight = 300
//    }
    
    var body: some View {
        Section {
            TabView(selection: $pageSelection) {
                ForEach(-50 ..< 51){ index in
                    ChartPage(pageOffset: index)
                        .tag(index)
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
