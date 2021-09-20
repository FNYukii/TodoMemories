//
//  FourthView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/20.
//

import SwiftUI

import SwiftUI

struct FourthView: View {
    
    //表示中のページ番号
    @State var currentPage = 0 {
        didSet {
            print("\(oldValue) -> \(currentPage)")
            if currentPage == 1 && oldValue == 0 || currentPage == 2 && oldValue == 1 || currentPage == 0 && oldValue == 2 {
                print("up")
            } else {
                print("down")
            }
        }
    }
    
    
    @State var offset = 0
    
    var body: some View {
        
        VStack {
            
            PageView([
                AnyView(Page1(offset: 3)),
                AnyView(Page2(offset: 5)),
                AnyView(Page3(offset: 7))
            ], currentPage: $currentPage)
            
//            Text("\(currentPage)")
            
        }
        
        
        
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
