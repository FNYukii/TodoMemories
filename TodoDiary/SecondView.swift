//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct SecondView: View {
    var planets = ["Mercury", "Venus", "Earth", "Mars"]
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Text("Apple")
                Text("Orange")
                Text("Strawberry")
            }
            .navigationBarTitle("Planets")
        }
    }
}
