//
//  SecondView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI

struct SecondView: View {
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
