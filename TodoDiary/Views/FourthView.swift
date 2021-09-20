//
//  FourthView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/20.
//

import SwiftUI

import SwiftUI

struct FourthView: View {
    
    @State private var currentPage = 0
    
    var body: some View {
        PageView([
            AnyView(Page1(offset: 3)),
            AnyView(Page2(offset: 5)),
            AnyView(Page3(offset: 7))
        ], currentPage: $currentPage)
    }
}

struct Page1: View {
    let offset: Int
    var body: some View {
        Text("Page1 \(offset)")
    }
}

struct Page2: View {
    let offset: Int
    var body: some View {
        Text("Page2 \(offset)")
    }
}

struct Page3: View {
    let offset: Int
    var body: some View {
        Text("Page3 \(offset)")
    }
}
