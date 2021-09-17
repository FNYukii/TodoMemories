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
            List {
                TextField("Search", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                ForEach(
                    planets.filter {
                        searchText.isEmpty ||
                        $0.localizedStandardContains(searchText)
                    },
                    id: \.self
                ) { eachPlanet in
                    Text(eachPlanet)
                }
            }
                .navigationBarTitle("Planets")
        }
    }
}
