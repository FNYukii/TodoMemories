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
        VStack {
            PageView([
                AnyView(Page1()),
                AnyView(Page2()),
                AnyView(Page3())
            ], currentPage: $currentPage)
        }
    }
}

struct Page1: View {
    var body: some View {
        Text("Page1")
    }
}

struct Page2: View {
    var body: some View {
        Text("Page2")
    }
}

struct Page3: View {
    var body: some View {
        Text("Page3")
    }
}
