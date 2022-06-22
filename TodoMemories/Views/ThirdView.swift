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
            List {
                ChartsSection()
            }
            .navigationTitle("stats")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func reloadView() {
        //TODO: 0番のページまでもどる
        print("reload ThirdView")
    }
}
