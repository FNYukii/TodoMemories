//
//  DayConverter.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import Foundation

class DayConverter {
    
    // Date -> 20210923
    static func toInt(from: Date) -> Int {
        let inputDate = from
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: inputDate)
        let month = calendar.component(.month, from: inputDate)
        let day = calendar.component(.day, from: inputDate)
        return year * 10000 + month * 100 + day
    }
    
    // DateComponents -> "Sunday, February 13, 2022", "2022年2月13日 日曜日"
    static func toStringUpToWeekday(from: Int) -> String {
        let date = toDate(from: from)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    // 20210923 -> Date
    static func toDate(from: Int) -> Date {
        let year = from / 10000
        let month = (from % 10000) / 100
        let day = (from % 100)
        let date = DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date!
        return date
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
    
    //  ["0", "1", "2", "3", ...] , ["0時", "1時", "2時", "3時", ...]
    static func hourStrings() -> [String] {
        var hourStrings: [String] = []
        for index in 0 ..< 24 {
            // DateCompontentsを生成
            var dateComponents = DateComponents()
            dateComponents.hour = index
            let date = Calendar.current.date(from: dateComponents)!
            // dayStringを生成
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("H")
            let hourString = dateFormatter.string(from: date)
            // 配列に追加
            hourStrings.append(hourString)
        }
        return hourStrings
    }
    
    // ["1", "2", "3", ...] , ["1日", "2日", "3日", ...]
    static func dayStrings() -> [String] {
        var dayStrings: [String] = []
        for index in 0 ..< 31 {
            // DateCompontentsを生成
            var dateComponents = DateComponents()
            dateComponents.day = index + 1
            let date = Calendar.current.date(from: dateComponents)!
            // dayStringを生成
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("d")
            let dayString = dateFormatter.string(from: date)
            // 配列に追加
            dayStrings.append(dayString)
        }
        return dayStrings
    }
    
    //  ["1", "2", "3", ...] , ["1月", "2月", "3月", ...]
    static func monthStrings() -> [String] {
        var monthStrings: [String] = []
        for index in 0 ..< 12 {
            // DateCompontentsを生成
            var dateComponents = DateComponents()
            dateComponents.month = index + 1
            let date = Calendar.current.date(from: dateComponents)!
            // dayStringを生成
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
            let monthString = dateFormatter.string(from: date)
            // 配列に追加
            monthStrings.append(monthString)
        }
        return monthStrings
    }
}
