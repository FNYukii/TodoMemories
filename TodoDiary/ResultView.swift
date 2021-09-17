//
//  ResultView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI

struct ResultView: View {
    
    let selectedDate: Date
    
    var body: some View {
        
        Form {
            Text("Apple")
            Text("Orange")
            Text("Strawberry")
        }
        
        .navigationBarTitle("\(ymdText(inputDate: selectedDate)) \(weekdayText(inputDate: selectedDate))")
    }
    
    //Date型変数を年月日のみの文字列に変換する
    func ymdText(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年 M月 d日"
        return dateFormatter.string(from: inputDate)
    }
    
    //Date型変数を曜日のみの文字列に変換する
    func weekdayText(inputDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let weekdayNumber = calendar.component(.weekday, from: inputDate)
        let weekdaySymbolIndex: Int = weekdayNumber - 1
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja") as Locale
        return formatter.shortWeekdaySymbols[weekdaySymbolIndex]
    }
    
}
