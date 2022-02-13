//
//  Converter.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/21.
//

import Foundation

class Converter {
    
    // 20210923 -> Date
    static func toDate(from: Int) -> Date {
        let inputYmd = from
        let year = inputYmd / 10000
        let month = (inputYmd % 10000) / 100
        let day = (inputYmd % 100)
        let dateComponent = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
        return dateComponent.date!
    }
    
    // Date -> 20210923
    static func toYmd(from: Date) -> Int {
        let inputDate = from
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: inputDate)
        let month = calendar.component(.month, from: inputDate)
        let day = calendar.component(.day, from: inputDate)
        return year * 10000 + month * 100 + day
    }
    
    // Date -> "2021年 10月 21日 木"
    static func toYmdwText(from: Date) -> String {
        let inputDate = from
        //年月日のテキストを生成
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年 M月 d日"
        let ymdText = dateFormatter.string(from: inputDate)
        //曜日のテキストを生成
        let calendar = Calendar(identifier: .gregorian)
        let weekdayNumber = calendar.component(.weekday, from: inputDate)
        let weekdaySymbolIndex: Int = weekdayNumber - 1
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja") as Locale
        let weekDayText = formatter.shortWeekdaySymbols[weekdaySymbolIndex]
        //２つのテキストを文字列連結する
        return ymdText + " " + weekDayText
    }
    
    // 20210923 -> "2021年 10月 21日 木"
    static func toYmdwText(from: Int) -> String {
        let date = toDate(from: from)
        return toYmdwText(from: date)
    }
        
    // Date -> "14:53"
    static func toHmText(from: Date) -> String {
        let inputDate = from
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: inputDate)
        let minute = calendar.component(.minute, from: inputDate)
        let hourStr = String(NSString(format: "%02d", hour))
        let minuteStr = String(NSString(format: "%02d", minute))
        return hourStr + ":" + minuteStr
    }
    
}
